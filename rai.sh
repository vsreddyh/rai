#!/bin/bash

CONFIG_FILE="./rai.config"

# Set your OpenRouter API key
source $CONFIG_FILE
# Define the model

# Make the API request
send_message() {
	curl -X POST "https://openrouter.ai/api/v1/chat/completions" \
		-H "Authorization: Bearer $OPENROUTER_API_KEY" \
		-H "Content-Type: application/json" \
		-d "$(jq -n \
			--arg model "$MODEL" \
			--arg prompt "$TXT $PROMPT" \
			'{model: $model, messages: [{role: "user", content: $prompt}]}')" |
		jq -r '.choices[0].message.content'
}

raihelp() {
	cat ./help.txt
	exit
}

#MODEL="google/gemini-2.0-flash-lite-preview-02-05:free"
#MODEL="cognitivecomputations/dolphin3.0-r1-mistral-24b:free"
#MODEL="cognitivecomputations/dolphin3.0-mistral-24b:free"
#MODEL="google/gemini-2.0-pro-exp-02-05:free"
#MODEL="qwen/qwen-vl-plus:free"
#MODEL="qwen/qwen2.5-vl-72b-instruct:free"
#MODEL="mistralai/mistral-small-24b-instruct-2501:free"
#MODEL="deepseek/deepseek-r1-distill-llama-70b:free"
#MODEL="google/gemini-2.0-flash-thinking-exp:free"
#MODEL="deepseek/deepseek-r1:free"
#MODEL="sophosympatheia/rogue-rose-103b-v0.2:free"
#MODEL="deepseek/deepseek-chat:free"
#MODEL="google/gemini-2.0-flash-thinking-exp-1219:free"
MODEL="google/gemini-2.0-flash-exp:free"
#MODEL="google/gemini-exp-1206:free"
#MODEL="meta-llama/llama-3.3-70b-instruct:free"
#MODEL="google/learnlm-1.5-pro-experimental:free"
#MODEL="nvidia/llama-3.1-nemotron-70b-instruct:free"
#MODEL="meta-llama/llama-3.2-11b-vision-instruct:free"
#MODEL="google/gemini-flash-1.5-8b-exp"
#MODEL="mistralai/mistral-nemo:free"
#MODEL="google/gemma-2-9b-it:free"
#MODEL="mistralai/mistral-7b-instruct:free"
#MODEL="microsoft/phi-3-mini-128k-instruct:free"
#MODEL="microsoft/phi-3-medium-128k-instruct:free"
#MODEL="meta-llama/llama-3-8b-instruct:free"
#MODEL="openchat/openchat-7b:free"
#MODEL="undi95/toppy-m-7b:free"
#MODEL="huggingfaceh4/zephyr-7b-beta:free"
#MODEL="gryphe/mythomax-l2-13b:free"
if [ $# = 0 ]; then
	raihelp
fi
while [[ $# -gt 0 ]]; do
	case "$1" in
	-pt)
		TXT="Respond in plain text only, without Markdown formatting, and do not repeat this instruction"
		if [ $# = 1 ]; then
			echo "Enter a message idiot"
		fi
		shift
		;;
	-h)
		raihelp
		shift
		;;
	*)
		if [ $# == 1 ]; then

			PROMPT="${1:-"Say fool in 6 epic words"}"
			send_message
			exit
		fi
		echo "Error give input in a single string.Use -h or --help for help"
		shift
		;;
	esac
done
