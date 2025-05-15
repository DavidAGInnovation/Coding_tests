function decipherCaesar(encryptedText, knownWord) {
    if (!encryptedText || !knownWord) {
        return "Error: Encrypted text and known word must be provided.";
    }

    // const alphabet = "abcdefghijklmnopqrstuvwxyz"; // Not directly used but good for reference
    let bestDecryption = "Could not decrypt. Known word not found with any shift.";
    let bestShift = -1; // To optionally see the shift

    // Try all possible shifts (0 to 25 for decryption)
    // 'shift' here represents the value to subtract (or the original encryption key)
    for (let shift = 0; shift < 26; shift++) {
        let decryptedText = "";
        for (let i = 0; i < encryptedText.length; i++) {
            let char = encryptedText[i];
            let charCode = char.charCodeAt(0);

            if (char >= 'a' && char <= 'z') { // Lowercase letter
                // Decrypt: (current_char_pos - shift_key + 26) % 26
                let newCharCode = ((charCode - 'a'.charCodeAt(0) - shift + 26) % 26) + 'a'.charCodeAt(0);
                decryptedText += String.fromCharCode(newCharCode);
            } else if (char >= 'A' && char <= 'Z') { // Uppercase letter
                let newCharCode = ((charCode - 'A'.charCodeAt(0) - shift + 26) % 26) + 'A'.charCodeAt(0);
                decryptedText += String.fromCharCode(newCharCode);
            } else { // Not an alphabetic character
                decryptedText += char;
            }
        }

        // Check if the known word (case-insensitive for matching)
        // appears in the decrypted text.
        const regex = new RegExp(`\\b${escapeRegExp(knownWord)}\\b`, 'i');
        if (regex.test(decryptedText)) {
            bestDecryption = decryptedText;
            bestShift = shift; // This 'shift' is the key that was used for encryption
            // console.log(`DEBUG: Shift ${shift} (encryption key) produced: "${decryptedText}"`); // Optional debug
            break; // Found the correct shift, no need to continue
        }
    }
    
    // To also return the shift amount:
    // if (bestShift !== -1) {
    //     console.log(`(Encryption shift key was: ${bestShift})`);
    // }
    return bestDecryption;
}

// Helper function to escape special characters in knownWord for regex
function escapeRegExp(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}


// --- Test Cases ---
let encrypted1 = "Uifsf jt b tfdsfu."; // "There is a secret." (encryption shift +3)
let known1 = "secret";
console.log(`Encrypted: "${encrypted1}", Known: "${known1}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted1, known1)}"`);

let encrypted2 = "Bmfy Boesb jt b Qsphsbn Nbohfs."; // "Alex Andra is a Program Manger." (encryption shift +1)
let known2 = "Program";
console.log(`\nEncrypted: "${encrypted2}", Known: "${known2}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted2, known2)}"`);

let encrypted3 = "Gdkkn Vnqkc!"; // "Hello World!" (encryption shift +25 or -1)
let known3 = "World";
console.log(`\nEncrypted: "${encrypted3}", Known: "${known3}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted3, known3)}"`);

// Original flawed test case "Exxego Jhtgpf!" is removed or commented out
// Corrected test case for "Attack AtDawn!" (encryption shift +4)
let encrypted4_corrected = "Exxego ExHear!";
let known4_corrected = "atdawn"; // known word can be lowercase
console.log(`\nEncrypted (Corrected): "${encrypted4_corrected}", Known: "${known4_corrected}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted4_corrected, known4_corrected)}"`); // Expected: "Attack AtDawn!"

let encrypted5 = "This is not encrypted."; // (encryption shift 0)
let known5 = "not";
console.log(`\nEncrypted: "${encrypted5}", Known: "${known5}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted5, known5)}"`);

let encrypted6 = "Vriw fo xlmw?"; // Known word not present with any consistent shift
let known6 = "secret";
console.log(`\nEncrypted: "${encrypted6}", Known: "${known6}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted6, known6)}"`);

let encrypted7 = "Uifsf jt b tfdsfu, Tfdsfu, TFDSFU!"; // "There is a secret, Secret, SECRET!" (encryption shift +3)
let known7 = "Secret"; // Known word can have different casing
console.log(`\nEncrypted: "${encrypted7}", Known: "${known7}"`);
console.log(`Decrypted: "${decipherCaesar(encrypted7, known7)}"`);