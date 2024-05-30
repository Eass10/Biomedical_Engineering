from flask import Flask, jsonify, request
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig, TrainingArguments, pipeline
from huggingface_hub import notebook_login
import os

os.environ['HF_TOKEN'] = "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"

ALLOWED_PARAMETERS = {
    "user_question",
}

## MAIN ##
app = Flask(__name__)


model_id = "meta-llama/Llama-2-7b-chat-hf"
device = 0
dtype = torch.bfloat16

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, torch_dtype=dtype, device_map="auto")



@app.route("/")
def index():
    return "I am up and running!"


@app.route("/search")
def search_data_from_user_inputs():
    # Check if there are any unkonwn arguments in the query
    # in case there is one, the API returns an error with the
    # list of unkown parameters.
    unknown = set(request.args) - ALLOWED_PARAMETERS
    if unknown:
        return f"Unknown parameters: {list(unknown)}", 400

    # All arguments are accepted and we can start processing them
    arguments = dict(request.args)

    # Get the user's question
    user_question = arguments.get("user_question")

    pipe = pipeline(task="text-generation", model=model, tokenizer=tokenizer, max_length=250)

    output = pipe(user_question, max_length=100, num_return_sequences=1)[0]['generated_text']

    return jsonify({"user_answer": output})

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8051, debug=True)