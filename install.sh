#!/bin/bash

# Завантаження загальних функцій (якщо потрібні)
source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)
printLogo

# Встановлення копонентів
sudo apt update
sudo apt install -y make pkg-config libssl-dev build-essential
ls /usr/bin/make

# Завантаження та виконання rush-install.sh
source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/rush-install.sh)

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

# Створення keystore
echo "Creating a new keystore..."
cast wallet new-mnemonic > mnemonic.txt
KEYSTORE_NAME="my_keystore"
cast wallet import --interactive "$KEYSTORE_NAME"

# Інформування користувача про поповнення keystore
echo "To complete setup, please fund the keystore with one of the following faucets:"
echo "- Google Faucet"
echo "- Stakely Faucet"
echo "- Quicknode Faucet"
echo "Keystores are saved in ~/.foundry/keystores"

# Виконання квізу
echo "Starting the quiz..."
if [ -d "examples/zkquiz" ]; then
    cd examples/zkquiz && make answer_quiz KEYSTORE_PATH=~/.foundry/keystores/my_keystore
else
    echo "Directory examples/zkquiz does not exist. Please check the path."
    exit 1
fi


