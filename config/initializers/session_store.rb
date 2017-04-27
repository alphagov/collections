# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :disabled

# Because we don't use sessions we don't need a secret key base. Pick a random
# one to satisfy Rails. If we ever were to start using sessions the key would
# need to be made static.
Rails.application.config.secret_key_base = SecureRandom.hex
