#!/bin/bash

CONFIG_FILE="./rai.config"

# Set your OpenRouter API key
source $CONFIG_FILE
# Define the model
MODEL="google/gemini-2.0-flash-lite-preview-02-05:free"

# Define the prompt
PROMPT="${1:-"Say something interesting!"}"

# Make the API request
send_message() {
	curl --no-progress-meter -X POST "https://openrouter.ai/api/v1/chat/completions" \
		-H "Authorization: Bearer $OPENROUTER_API_KEY" \
		-H "Content-Type: application/json" \
		-d "$(jq -n \
			--arg model "$MODEL" \
			--arg prompt "$PROMPT" \
			'{model: $model, messages: [{role: "user", content: $prompt}]}')" |
		jq -r '.choices[0].message.content'
}
send_message
