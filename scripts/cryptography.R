# Let's build a Simple Hashing functions from Scratch
naivehash <- function(val) sum(utf8ToInt(val)) %% 100 
naivehash("Hello Hashed Message!")
naivehash("Hello Hashed Message 2!")

# Hashing functions (SHA-256, MD5, ...)
# https://en.wikipedia.org/wiki/SHA-2
install.packages("digest")
library(digest)

hashed.message = digest("Say hallo to a better hash!", algo="sha256")
print(paste("The SHA-256 hash is", nchar(hashed.message), "characters long"))
print(paste("Number of possible hashes:", 16^nchar(hashed.message))) # Why? 16: The hash is in a hexadecmal format
# Hash collision? Not likely. Check the last chart in the URL below. We are using a 64*8=
# : https://preshing.com/20110504/hash-collision-probabilities/


# Encryptions
# ===========

# Symmetric encryption: Caesar
# ----------------------------

install.packages("caesar")
library(caesar)

coded = caesar("Message to be encoded", shift=1)
print(paste("Encoded message:", coded))
decoded = caesar(coded, shift=1, decrypt = TRUE)
print(paste("Decoded message:", decoded))


# Asymmetric Encryption
# ---------------------

install.packages('PKI')
library(PKI)

# Create a keypair and save them in PEM format to variables
key <- PKI.genRSAkey(bits = 2048L)

prv.pem <- PKI.save.key(key, private=TRUE)
print(prv.pem)

pub.pem <- PKI.save.key(key, private=FALSE)
print(pub.pem)

# Extract the Public key from the public key's PEM format
pub.key <- PKI.load.key(pub.pem)
prv.key <- PKI.load.key(prv.pem)

# Encrypt with the public key
bytes.to.encode = charToRaw("Hello, asymmetric encryption!")
encrypted <- PKI.encrypt(bytes.to.encode, pub.key)
print(encrypted)

# Decrypt with the private key
decrypted <- rawToChar(PKI.decrypt(encrypted, prv.key))
print(decrypted)

# Save the keys to a file, then load them back
write(pub.pem, file="id_rsa.pub") # Save Public key 
write(prv.pem, file="id_rsa")     # Save Private key

pub.pem.loaded <- scan("id_rsa.pub", what='list', sep='\n') # Load
prv.pem.loaded <- scan("id_rsa", what='list', sep='\n') # Load

# Extract the key objects from the PEM file
pub.key.loaded <- PKI.load.key(pub.pem.loaded) 
prv.key.loaded <- PKI.load.key(prv.pem.loaded) 

# Let's encrypt and decrypt, again!
encrypted.again <- PKI.encrypt(charToRaw("Hello, asymmetric encryption, again!"), pub.key.loaded)
decrypted.again <- rawToChar(PKI.decrypt(encrypted.again, prv.key.loaded))
print(decrypted.again)

## Exercise

# 1. Pair up.
# 2. Generate and exchange public keys
# 3. Send one encrypted question to your peer (both of you).
# 4. Send an encrypted answer back to your peer and decrypt the answer. 

# Bonus: 
# Let's make this even more secure. Every message must be encoded by both parties keypairs. 
# How could you make such a solution work? Think about it and implement a solution with your peer.
