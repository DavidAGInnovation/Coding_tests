#!/usr/bin/perl
use strict;
use warnings;

# --- Configuration ---
my @event_types_to_track = qw(ERROR WARNING INFO); # Define event types here

# --- Get log file from command line argument ---
my $log_file = $ARGV[0];
unless (defined $log_file && -f $log_file && -r $log_file) {
    die "Usage: $0 <logfile>\nPlease provide a valid and readable log file.\n";
}

# --- Initialize data structures ---
my %event_counts;
my %most_recent_events; # Store the full line for the most recent event

# Initialize counts to 0 for all tracked types
foreach my $type (@event_types_to_track) {
    $event_counts{$type} = 0;
}

# --- Process the log file ---
open my $fh, '<', $log_file or die "Could not open file '$log_file': $!";

while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/; # Skip empty lines

    # Attempt to match the general log line structure
    # Example: 2024-09-01 12:00:01 EVENT_TYPE Message
    # This regex is basic; a more robust one might be needed for complex logs
    if ($line =~ /^(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\s+(\S+)\s*(.*)$/) {
        my $timestamp = $1;
        my $found_event_type = $2;
        my $message_body = $3; # The rest of the line after event type

        # Check if this found_event_type is one we are tracking
        foreach my $track_type (@event_types_to_track) {
            if ($found_event_type eq $track_type) {
                $event_counts{$track_type}++;
                # Store the full line as the most recent event for this type
                # The timestamp allows us to confirm recency if needed, but simple overwrite works
                # because we process the file chronologically.
                $most_recent_events{$track_type} = {
                    timestamp => $timestamp,
                    full_message => "$found_event_type $message_body" # Reconstruct message as seen in output
                };
                last; # Found its type, no need to check other track_types for this line
            }
        }
    }
}
close $fh;

# --- Print the summary ---

# 1. Event Counts
print "Event Counts:\n";
# Print in a specific order if desired, or sort keys
foreach my $event_type (sort keys %event_counts) { # Or use @event_types_to_track for defined order
    printf "%s: %d occurrence%s\n",
           $event_type,
           $event_counts{$event_type},
           ($event_counts{$event_type} == 1 ? '' : 's');
}
print "\n"; # Separator

# 2. Most Recent Event Details
print "Most Recent Event Details:\n";
foreach my $event_type (sort keys %most_recent_events) { # Or use @event_types_to_track
    if (exists $most_recent_events{$event_type}) {
        my $event_details = $most_recent_events{$event_type};
        print "Most Recent $event_type:\n";
        print "  Timestamp: $event_details->{timestamp}\n";
        print "  Message: $event_details->{full_message}\n\n";
    } else {
        print "No '$event_type' events found.\n\n";
    }
}

# Handle cases where a tracked event type had 0 occurrences for recent events section
foreach my $track_type (@event_types_to_track) {
    unless (exists $most_recent_events{$track_type}) {
        print "No '$track_type' events found for 'Most Recent' details.\n\n";
    }
}