package config

type Config struct {
	ModelAgentConfig ModelAgentConfig `json:"modelAgentConfig" yaml:"modelAgentConfig"`
	LogConfig        LogConfig        `json:"logConfig" yaml:"logConfig"`
}

type LogConfig struct {
	Level             string   `json:"level" yaml:"level"`
	Encoding          string   `json:"encoding" yaml:"encoding"`
	OutputPaths       []string `json:"outputPaths" yaml:"outputPaths"`
	ErrorOutputPaths  []string `json:"errorOutputPaths" yaml:"errorOutputPaths"`
	Development       bool     `json:"development" yaml:"development"`
	DisableCaller     bool     `json:"disableCaller" yaml:"disableCaller"`
	DisableStacktrace bool     `json:"disableStacktrace" yaml:"disableStacktrace"`
}

type ModelAgentConfig struct {
	Name string `json:"name" yaml:"name"`
	// Description of the agent's capabilities.
	// Helps other agents determine whether to transfer tasks to this agent.
	// Optional. If empty, the agent can still run standalone but cannot be used as
	// a sub-agent tool via NewAgentTool (which requires a non-empty Description).
	Description string `json:"description" yaml:"description"`
	// Instruction used as the system prompt for this agent.
	// Optional. If empty, no system prompt will be used.
	// Supports f-string placeholders for session values in default GenModelInput, for example:
	// "You are a helpful assistant. The current time is {Time}. The current user is {User}."
	// These placeholders will be replaced with session values for "Time" and "User".
	Instruction string `json:"instruction" yaml:"instruction"`
}
