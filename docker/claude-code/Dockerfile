FROM node:22-slim
ARG CLAUDE_VERSION=latest
LABEL claude.version="$CLAUDE_VERSION"
RUN npm install -g @anthropic-ai/claude-code
ARG USER_UID=501
RUN useradd -m -s /bin/bash -u $USER_UID claude
USER claude
ENTRYPOINT ["claude"]
CMD ["--dangerously-skip-permissions"]
