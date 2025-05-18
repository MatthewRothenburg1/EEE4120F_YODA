import subprocess


key = input("Enter a 4 character key (4 char max): ")
while( len(key) > 4 or len(key) < 1):
    print("Key must be between 1 and 4 characters.")
    key = input("Enter a 4 character key (4 char max): ")


message = input("Enter a message to encrypt: (1023 char max):")
while( len(message) > 1023 or len(message) < 1):
    print("Message must be between 1 and 1023 characters.")
    message = input("Enter a message to encrypt: (1023 char max):")


with open("data.txt", "w") as f:
    f.write(key + "\n")
    f.write(message + "\n")
    
# Compile
#subprocess.run(["iverilog", "-o", "design.out", "DEA_tb.v", "DEA.v", "key_reg.v"])
subprocess.run(["iverilog", "-o", "design.out", "UI_tb.v", "DEA.v", "key_reg.v"])


# Run simulation
result = subprocess.run(["vvp", "design.out"], capture_output=True, text=True)
key_ints = [ord(char) for char in key]

msg = ""
encrypted_message = ""

for i in range(len(message)):
    char = result.stdout.splitlines()[i]
    asci_int = int(char, 16) ^ key_ints[i % len(key_ints)]
    msg += chr(asci_int)
    encrypted_message += chr(int(char, 16))


print(encrypted_message)
print(msg)
