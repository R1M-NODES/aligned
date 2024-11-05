#!/bin/bash

# Завантаження загальних функцій (якщо потрібні)
source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)
printLogo

# Встановлення Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"  # Додає Rust в PATH
echo "Rust version: $(rustc --version)"

# Встановлення Foundry і Cast
echo "Installing Foundry and Cast..."
curl -L https://foundry.paradigm.xyz | bash

# Оновлення PATH для доступу до Foundry та Cast у поточному сеансі
export PATH="$HOME/.foundry/bin:$PATH"
echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.profile  # Додає в PATH для наступних сеансів
source ~/.profile  # Завантаження оновленого PATH

# Завантаження та встановлення останньої версії Foundry
foundryup

echo "Foundry and Cast installed."

# Клонування репозиторію
echo "Cloning the aligned_layer repository..."
git clone https://github.com/yetanotherco/aligned_layer.git && cd aligned_layer

# Вибір між створенням нового keystore або імпортом існуючого
echo "Select an option:"
echo "1. Create a new keystore"
echo "2. Import an existing keystore"
read -p "Enter 1 or 2: " choice

KEYSTORE_NAME="my_keystore"

if [ "$choice" = "1" ]; then
    # Створення нового keystore
    echo "Creating a new keystore..."
    cast wallet new-mnemonic > mnemonic.txt
    cast wallet import --interactive "$KEYSTORE_NAME"
    echo "Keystore created and saved as $KEYSTORE_NAME."
elif [ "$choice" = "2" ]; then
    # Імпорт існуючого keystore
    read -p "Enter the path to your keystore file: " keystore_path
    cast wallet import --interactive "$keystore_path"
    echo "Keystore imported from $keystore_path."
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Інформування користувача про поповнення keystore
echo "To complete setup, please fund the keystore with one of the following faucets:"
echo "- Google Faucet"
echo "- Stakely Faucet"
echo "- Quicknode Faucet"
echo "Keystores are saved in ~/.foundry/keystores"

# Виконання квізу
echo "Starting the quiz..."
cd examples/zkquiz
if [ "$choice" = "1" ]; then
    make answer_quiz KEYSTORE_PATH=~/.foundry/keystores/"$KEYSTORE_NAME"
else
    make answer_quiz KEYSTORE_PATH="$keystore_path"
fi
