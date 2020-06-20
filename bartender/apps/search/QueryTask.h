/*
 * Copyright 2020 Yeolar
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <raster/Task.h>

namespace bartender {

class QueryTask : public raster::Task {
 public:
  QueryTask(const raster::Context& context) : Task(context) {}

  void operator()() override {
    printf("Query: %s, %s\n",
           context_.request->traceid().c_str(),
           context_.request->query().c_str());
  }
};

} // namespace bartender
