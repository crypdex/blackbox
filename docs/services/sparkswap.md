## Migration v1 => v2

> Before migrating or updating, backup you wallet data!

### Environment variable changes

| Previous                  | Current              | Notes                                             |
| ------------------------- | -------------------- | ------------------------------------------------- |
| SPARKSWAP_BTC_RPCHOST     | BITCOIN_RPCHOST      |
| SPARKSWAP_BTC_RPCPASSWORD | BITCOIN_RPCPASSWORD  |
| SPARKSWAP_BTC_RPCUSER     | BITCOIN_RPCUSER      |
| SPARKSWAP_LTC_RPCHOST     | LITECOIN_RPCHOST     |
| SPARKSWAP_LTC_RPCPASSWORD | LITECOIN_RPCPASSWORD |
| SPARKSWAP_LTC_RPCUSER     | LITECOIN_RPCUSER     |
| SPARKSWAP_SECURE_PATH     | -                    | Now conventionally at `SPARKSWAP_DATA_DIR`/secure |

- Copy the directory at `~/.sparkswap/secure` (or at `SPARKSWAP_SECURE_PATH`) to `${DATA_DIR}/sparkswap/secure`

  ```shell
  $ cp -r ~/.sparkswap/secure
  ```
