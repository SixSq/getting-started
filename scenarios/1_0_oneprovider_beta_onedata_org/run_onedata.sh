#!/bin/bash

# Scenario has to be defined before the source
SCENARIO_NAME='10oneproviderbetaonedataorg'

source ../../bin/run_onedata.sh

clean_scenario() {
	: # pass
}

main "$@"