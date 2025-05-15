require 'csv'
require 'set' # For efficient tracking of seen product IDs

INPUT_FILENAME = 'products.csv'
OUTPUT_FILENAME = 'cleaned_products.csv'

# --- Helper Functions ---

# Normalize price: remove currency symbols, extra spaces, convert to float with 2 decimal places.
def normalize_price(price_str)
  return "0.00" if price_str.nil? || price_str.strip.empty?

  # Remove common currency symbols and any non-digit/non-decimal point characters
  # Allow for a single decimal point.
  cleaned_price = price_str.to_s.gsub(/[^\d\.]/, '')

  # Handle cases where multiple decimal points might remain after initial gsub if input was malformed
  parts = cleaned_price.split('.')
  if parts.length > 1
    cleaned_price = parts[0] + '.' + parts[1..].join('')
  end

  # If still not a valid float string (e.g., just "."), default to 0.0
  begin
    price_float = Float(cleaned_price)
    format("%.2f", price_float)
  rescue ArgumentError
    "0.00"
  end
end

# Normalize stock: convert to integer, set non-integer/empty to 0.
def normalize_stock(stock_str)
  return 0 if stock_str.nil?

  cleaned_stock = stock_str.to_s.strip
  return 0 if cleaned_stock.empty?

  begin
    Integer(cleaned_stock)
  rescue ArgumentError
    0 # If it's not a valid integer string
  end
end

# Normalize email: convert to lowercase.
def normalize_email(email_str)
  return "" if email_str.nil? # Or handle nil as you prefer, e.g., keep it nil
  email_str.to_s.strip.downcase
end

# --- Main Processing ---
def process_csv(input_file, output_file)
  seen_product_ids = Set.new
  cleaned_rows = []
  header = nil

  unless File.exist?(input_file)
    puts "Error: Input file '#{input_file}' not found."
    return
  end

  begin
    CSV.foreach(input_file, headers: true, header_converters: :symbol) do |row|
      header ||= row.headers # Store header once

      product_id = row[:product_id]&.strip

      # 1. Duplicate Product IDs: Only keep the first occurrence
      if product_id.nil? || product_id.empty? || seen_product_ids.include?(product_id)
        # puts "Skipping duplicate or empty product_id: #{product_id}"
        next
      end
      seen_product_ids.add(product_id)

      # Process other fields
      name = row[:name]&.strip # Also good to strip name
      category = row[:category]&.strip # And category

      # 2. Price Formatting
      price = normalize_price(row[:price])

      # 3. Stock Values
      stock = normalize_stock(row[:stock])

      # 4. Supplier Emails
      supplier_email = normalize_email(row[:supplier_email])

      cleaned_rows << [product_id, name, category, price, stock, supplier_email]
    end

    # Write the cleaned data to the output CSV
    if header.nil? && cleaned_rows.empty?
      puts "Input file might be empty or only contained headers/duplicates."
      # Create an empty output file with headers if input was just headers
      if File.exist?(input_file) && CSV.read(input_file, headers: true).headers
         original_headers = CSV.read(input_file, headers: true).headers
         CSV.open(output_file, "wb") do |csv_out|
           csv_out << original_headers.map(&:to_s) # Convert symbols back to strings for output
         end
         puts "Created empty output file with original headers: #{output_file}"
      end
      return
    elsif header.nil?
      puts "Could not determine headers from input file."
      return
    end


    CSV.open(output_file, "wb") do |csv_out|
      # Convert header symbols back to strings for output
      csv_out << header.map(&:to_s)
      cleaned_rows.each do |cleaned_row|
        csv_out << cleaned_row
      end
    end

    puts "Processing complete. Cleaned data saved to '#{output_file}'"
    puts "Processed #{cleaned_rows.length} unique products."

  rescue CSV::MalformedCSVError => e
    puts "Error: Malformed CSV in '#{input_file}'. Details: #{e.message}"
  rescue StandardError => e
    puts "An unexpected error occurred: #{e.message}"
    puts e.backtrace.join("\n")
  end
end

# --- Create a dummy products.csv for testing ---
def create_dummy_csv(filename)
  headers = %w[product_id name category price stock supplier_email]
  data = [
    ['P001', 'Laptop Pro', 'Electronics', ' $1200.50 ', ' 25 ', 'SupplierA@Example.COM'],
    ['P002', 'Coffee Maker', 'Appliances', '€75', '15items', 'supplier.b@example.net'],
    ['P001', 'Laptop Pro X', 'Electronics', '1250', '10', 'SupplierA_New@Example.COM'], # Duplicate P001
    ['P003', 'Wireless Mouse', 'Electronics', '25.99 USD', '', 'contact@techstore.org'], # Empty stock
    ['P004', 'Office Chair', 'Furniture', ' 150.00 ', '5 ', 'Sales@FurnitureWorld.Com'],
    ['P005', 'Desk Lamp', 'Furniture', '30.5', 'invalid', 'help@lighting.co'], # Invalid stock
    ['P006', 'Book "Ruby Deep Dive"', 'Books', '£29.99', '50', 'orders@BookPublishers.UK'],
    ['P007', 'T-Shirt', 'Apparel', '15', '100', 'INFO@CLOTHING.COM'], # Price needs .00
    [nil, 'Mystery Item', 'Misc', '10.00', '5', 'null@example.com'], # Nil product_id
    ['P008', '  Extra Space Product  ', ' Gadgets ', ' 49.99 ', ' 20 ', '  leading@space.com  '],
    ['P009', 'Product Nine', 'Category X', ' malformed price ', ' 30 ', 'test9@example.com'],
    ['P010', 'Product Ten', 'Category Y', '1,234.56', '12', 'test10@example.com'] # Price with comma
  ]
  CSV.open(filename, "wb") do |csv|
    csv << headers
    data.each { |row| csv << row }
  end
  puts "Dummy CSV file '#{filename}' created for testing."
end

# --- Run the script ---
# Create a dummy file if products.csv doesn't exist, for easy testing
create_dummy_csv(INPUT_FILENAME) unless File.exist?(INPUT_FILENAME)

process_csv(INPUT_FILENAME, OUTPUT_FILENAME)