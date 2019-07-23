deploy_config:
	curl -XPUT -d @l7_config/api_service_splitter_100.json http://localhost:8500/v1/config 
	curl -XPUT -d @l7_config/api_service_resolver.json http://localhost:8500/v1/config 
	curl -XPUT -d @l7_config/api_service_defaults.json http://localhost:8500/v1/config 
