#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
repository_dir=$(pwd)
app_dir="$repository_dir/Genetics Lab.swiftpm"
mkdir -p .build/core-checks
swiftc -swift-version 5 -parse-as-library \
  "$app_dir/Genetics.swift" \
  "$app_dir/PlantCatalog.swift" \
  "$app_dir/Lesson.swift" \
  "$app_dir/LessonContent.swift" \
  "$app_dir/Experiment.swift" \
  "$repository_dir/Tests/GeneticsCoreChecks/GeneticsCoreChecks.swift" \
  -o .build/core-checks/checks
.build/core-checks/checks
