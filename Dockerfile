# Use the official Node.js 18 Alpine image
FROM node:22-bookworm-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps --omit=dev

# Copy the rest of the application code
COPY . .

# Create a non-root user to run the app
RUN groupadd --system --gid 1001 nodejs && useradd --system --uid 1001 --gid nodejs --create-home appuser

# Change ownership of the app directory to the nodejs user
RUN chown -R appuser:nodejs /usr/src/app
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD node -e "fetch('http://127.0.0.1:3000/health/ready').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["npm", "start"]
