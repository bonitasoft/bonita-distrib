# start by adding a few lines specific to docker logging:
BEGIN {
	print "handlers = java.util.logging.ConsoleHandler\n"
	print ".handlers = java.util.logging.ConsoleHandler"
	print "# The default logging level when not specifically defined"
	print ".level= INFO\n"
	print "# The minimum level to log"
	print "java.util.logging.ConsoleHandler.level = INFO"
	print "java.util.logging.ConsoleHandler.formatter = org.apache.juli.BonitaSimpleFormatter\n"
}
# read file and skip all lines until finding the marker:
($0 ~ /^##### DO NOT MODIFY THIS LINE.*/) { started = ! started; next }
#  then print all following lines without modifying them:
started { print }