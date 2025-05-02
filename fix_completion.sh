#!/bin/bash

# Fix kubectx and kubens completion
echo 'function _kubectx_completion() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=$(kubectl config get-contexts -o name)
  
  if [[ ${cur} == * ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi
}
complete -F _kubectx_completion kubectx

function _kubens_completion() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=$(kubectl get namespaces -o name | cut -d/ -f2)
  
  if [[ ${cur} == * ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi
}
complete -F _kubens_completion kubens' > ~/.kubectx_completion.bash

# Add to bashrc if not already there
grep -q "source ~/.kubectx_completion.bash" ~/.bashrc || echo 'source ~/.kubectx_completion.bash' >> ~/.bashrc

# Create aliases
grep -q "alias kctx=kubectx" ~/.bashrc || echo 'alias kctx=kubectx' >> ~/.bashrc
grep -q "alias kns=kubens" ~/.bashrc || echo 'alias kns=kubens' >> ~/.bashrc

echo "Setup complete. Please run 'source ~/.bashrc' to apply changes."
