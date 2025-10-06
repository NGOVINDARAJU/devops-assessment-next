# Get ready with Node.js, the tool Next.js needs to run
FROM node:18-alpine

# Make a space inside the box for your app’s code
WORKDIR /app

# Copy the files from your app to the box
COPY package.json package-lock.json* ./
RUN npm install

# Copy the rest of your code
COPY . .

# Build the app for production
RUN npm run build

# Tell Docker how to start your app
EXPOSE 3000
CMD ["npm", "start"]
