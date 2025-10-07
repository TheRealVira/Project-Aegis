# Project Aegis - Self-healing infrastructure demo makefile
# This makefile provides commands to streamline working with the Helm charts

# Configuration variables
CHART_DIR = IaC/charts
UMBRELLA_CHART = $(CHART_DIR)/aegis
NAMESPACE = demo
RELEASE_NAME = aegis-demo
KUBECTL = kubectl
HELM = helm
K8S_CONTEXT = $(shell kubectl config current-context)

.PHONY: install
install: update-deps
	$(HELM) install $(RELEASE_NAME) $(UMBRELLA_CHART) --namespace $(NAMESPACE) --create-namespace

.PHONY: uninstall
uninstall:
	$(HELM) uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

.PHONY: update-deps
update-deps:
	cd $(UMBRELLA_CHART) && $(HELM) dependency update

.PHONY: upgrade
upgrade: update-deps
	$(HELM) upgrade $(RELEASE_NAME) $(UMBRELLA_CHART) --namespace $(NAMESPACE)

.PHONY: dashboard
dashboard:
	@echo "✨ Project Aegis Dashboard ✨"
	@echo "============================"
	@echo "🔍 Access services at:"
	@echo "📊 Grafana:    http://localhost:3000"
	@echo "📈 Prometheus: http://localhost:9090"
	@echo "🌐 Example1:   http://localhost:8081"
	@echo "🌐 Example2:   http://localhost:8082"
	@echo "============================"
	@echo "Press Ctrl+C to stop all port forwards"
	@echo "Starting port forwards in new windows..."
	@cmd /c start cmd /c "title Aegis - Grafana && kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-grafana 3000:3000"
	@cmd /c start cmd /c "title Aegis - Prometheus && kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-prometheus-server 9090:80" 
	@cmd /c start cmd /c "title Aegis - Example1 && kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-example1-service 8081:80"
	@cmd /c start cmd /c "title Aegis - Example2 && kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-example2-service 8082:80"
	@echo "Port forwards started in separate command windows"
	@echo "Close the windows to stop the port forwards"
