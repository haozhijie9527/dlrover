// Copyright 2022 The DLRover Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package optimizer

import (
	"github.com/intelligent-machine-learning/easydl/brain/pkg/config"
	optapi "github.com/intelligent-machine-learning/easydl/brain/pkg/optimizer/api"
	optconfig "github.com/intelligent-machine-learning/easydl/brain/pkg/optimizer/config"
	pb "github.com/intelligent-machine-learning/easydl/brain/pkg/proto"
)

// ConfigRetrieverManager is the struct of config retriever manager
type ConfigRetrieverManager struct {
	conf       *config.Config
	retrievers map[string]optapi.ConfigRetriever
}

// NewConfigRetrieverManager returns a new config retriever manager
func NewConfigRetrieverManager(conf *config.Config) *ConfigRetrieverManager {
	return &ConfigRetrieverManager{
		conf:       conf,
		retrievers: make(map[string]optapi.ConfigRetriever),
	}
}

// RetrieveOptimizerConfig retrieves optimizer config from pb optimize config
func (m *ConfigRetrieverManager) RetrieveOptimizerConfig(conf *pb.OptimizeConfig) (*optconfig.OptimizerConfig, error) {
	retriever, _ := m.retrievers[conf.OptimizerConfigRetriever]
	return retriever.Retrieve(conf)
}
