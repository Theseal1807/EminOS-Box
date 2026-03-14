# Install ScopeBuddy
[group('Utility')]
install-scopebuddy:
    #!/usr/bin/env bash
    sudo curl -Lo /usr/local/bin/scopebuddy https://raw.githubusercontent.com/HikariKnight/ScopeBuddy/refs/heads/main/bin/scopebuddy
    sudo chmod +x /usr/local/bin/scopebuddy
    echo "ScopeBuddy installed!"
