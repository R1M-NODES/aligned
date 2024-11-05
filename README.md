<b> Install Aligned </b>

```
bash <(curl -s https://raw.githubusercontent.com/R1M-NODES/aligned/master/install.sh)
```

<b> Delete Wallet </b>

```
rm -rf $HOME/.foundry/keystores/wallet
```

<b> Add wallet+Setup</b>

```
cast wallet import --interactive wallet

cd examples/zkquiz && make answer_quiz KEYSTORE_PATH=~/.foundry/keystores/my_keystore
```

<b> Delete Full </b>

```
rm -rf $HOME/aligned_layer
```
