FROM ghcr.io/homebrew/brew:latest

# Install build dependency (allow API/updates to get dotnet 10)
# RUN brew install dotnet

ENV HOMEBREW_NO_AUTO_UPDATE=1

# Copy the formula into the tap
RUN mkdir -p /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/lbussell/homebrew-dnvm/Formula
COPY --chown=linuxbrew:linuxbrew Formula/dnvm.rb /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/lbussell/homebrew-dnvm/Formula/dnvm.rb

# Initialize it as a git repo so brew recognizes it as a tap
RUN cd /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/lbussell/homebrew-dnvm && \
    git init && \
    git add -A && \
    git -c user.email="test@test.com" -c user.name="Test" commit -m "init"

# Install dnvm from the local tap
RUN brew install lbussell/dnvm/dnvm

# Verify it works
RUN dnvm --help
RUN brew test lbussell/dnvm/dnvm

CMD ["dnvm", "--help"]
