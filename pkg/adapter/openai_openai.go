package adapter

import (
	"encoding/json"
	"github.com/sashabaranov/go-openai"
	myopenai "simple-one-api/pkg/openai"
	"strings"
)

func OpenAIResponseToOpenAIResponse(resp *openai.ChatCompletionResponse) *myopenai.OpenAIResponse {
	if resp == nil {
		return nil
	}

	var choices []myopenai.Choice
	for _, choice := range resp.Choices {
		message := myopenai.ResponseMessage{
			Role:    choice.Message.Role,
			Content: choice.Message.Content,
		}
		var logProbs json.RawMessage
		if choice.LogProbs != nil {
			logProbs, _ = json.Marshal(choice.LogProbs)
		}
		choices = append(choices, myopenai.Choice{
			Index:        choice.Index,
			Message:      message,
			LogProbs:     &logProbs,
			FinishReason: string(choice.FinishReason),
		})
	}

	usage := myopenai.Usage{
		PromptTokens:     resp.Usage.PromptTokens,
		CompletionTokens: resp.Usage.CompletionTokens,
		TotalTokens:      resp.Usage.TotalTokens,
	}

	return &myopenai.OpenAIResponse{
		ID:                resp.ID,
		Object:            resp.Object,
		Created:           resp.Created,
		Model:             resp.Model,
		SystemFingerprint: resp.SystemFingerprint,
		Choices:           choices,
		Usage:             &usage,
	}
}

// OpenAIMultiContentRequestToOpenAIContentResponse 转换含多内容消息的请求到单内容响应。
func OpenAIMultiContentRequestToOpenAIContentRequest(oaiReq *openai.ChatCompletionRequest) {
	for i := range oaiReq.Messages {
		msg := &oaiReq.Messages[i]
		//mylog.Logger.Info("1")
		if len(msg.MultiContent) > 0 && msg.Content == "" {
			//mylog.Logger.Info("2")
			for _, content := range msg.MultiContent {
				//mylog.Logger.Info(content.Text)
				if content.Type == openai.ChatMessagePartTypeText {
					msg.Content += content.Text
				} else if content.Type == openai.ChatMessagePartTypeImageURL {
					if strings.HasPrefix(content.ImageURL.URL, "http") {
						msg.Content += "\n" + content.ImageURL.URL
					}
				}
			}
			msg.MultiContent = nil
		}
	}
}
