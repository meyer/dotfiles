# Copy public key to the clipboard
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# grc overrides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
	alias ls="command gls -F --color"
	alias l="command gls -lAh --color"
	alias ll="command gls -l --color"
	alias la='command gls -A --color'
fi