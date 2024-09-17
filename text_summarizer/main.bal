import ballerina/io;
import ballerinax/openai.chat;

configurable string OPENAI_API_KEY = ?;

public function main(string filePath) returns error? {
	// Create a new chat client to interact with the OpenAI API.
	final chat:Client openaiChatClient = check new({
		auth: {
			token: OPENAI_API_KEY
		}
	});

	// Read the content of the file.
	string fileContent = check io:fileReadString(filePath);
	io:println(`File content: ${fileContent}`, "\n");

	// Create a chat completion request to summarize the text.
	chat:CreateChatCompletionRequest request = {
		model: "gpt-4o-mini",
		messages: [
			{
				role: "system",
				content: "Summarize the text."
			},
			{
				role: "user",
				content: fileContent
			}
		]
	};

	// Get the completion response from the OpenAI API.
	chat:CreateChatCompletionResponse response = check openaiChatClient->/chat/completions.post(request);
	string? summary = response.choices[0].message.content;

	// Print the summary.
	if summary is string {
		io:println(`Summary: ${summary}`, "\n");
	} else {
		io:println("Failed to generate a summary.");
	}
}
