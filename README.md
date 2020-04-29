# Telegram Bot Playground

Play project to interact with a Telegram Bot  
t.me/PlgrndBot

## Requirements

You need to have the following tools installed:

- nvm (or please see `.nvmrc` for node version)
- firebase-tools (`npm install -g firebase-tools`)
- a bot see [official doc](https://core.telegram.org/bots#creating-a-new-bot)
- curl and jq (optional for some make targets)

## How it works?

A **Makefile** provides some shortcuts to help you. Just run

```bash
$ make
```

to see a help menu.

## Functions Dev

You usually want to interact with another bot during development, to avoid unwanted
side effects with prod.  
Run `make config` to generate a local configuration file, and fill-in your own bot.

To launch the functions, run `make dev`.

Then to make your functions reachable by Telegram, you need to expose your
localhost, you can use a free service for this: [localhost.run](http://localhost.run/)  
There is no tool to install, just use SSH like this:

```bash
ssh -R 80:localhost:5001 ssh.localhost.run
```

Finally, you need to set the webhook on your bot.  
Before that, be sure you edited the previously generated configuration file, then run:

```bash
make webhook URL=https://xxx-yyy.localhost.run/tgbotplayground/us-central1/webhook
```

## Useful links

https://firebase.google.com/docs/functions/config-env  
https://firebase.google.com/docs/functions/local-emulator  
https://core.telegram.org/bots/webhooks  
https://core.telegram.org/bots/api
