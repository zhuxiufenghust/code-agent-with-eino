package agent

import (
	"context"

	"github.com/cloudwego/eino/adk"
	"github.com/zhuxiufenghust/code-agent-with-eino/internal/log"
)

type Agent struct {
	r  *adk.Runner
	cp adk.CheckPointStore
}

type Option func(*Agent)

func WithCheckPointStore(store adk.CheckPointStore) Option {
	return func(agent *Agent) {
		agent.cp = store
	}
}

func NewAgent(ctx context.Context, opts ...Option) *Agent {
	agent := &Agent{}
	for _, opt := range opts {
		opt(agent)
	}

	agentConfig := &adk.ChatModelAgentConfig{}

	ag, err := adk.NewChatModelAgent(ctx, agentConfig)
	if err != nil {
		panic(err)
	}
	runner := adk.NewRunner(ctx, adk.RunnerConfig{
		Agent:           ag,
		CheckPointStore: agent.cp,
	})

	agent.r = runner
	log.Info("Agent created successfully")
	return agent
}
