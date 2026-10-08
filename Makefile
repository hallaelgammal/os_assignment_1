DIR=test_dir
MALICIOUS_DIR=malicious_dir
INTERVAL=5

setup:
antivirus:
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)
restore:
	./restore.sh $(DIR) $(MALICIOUS_DIR)

	mkdir -p $(MALICIOUS_DIR)
