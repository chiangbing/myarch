###########################
# My Customized Variables #
###########################

# Default editor
export EDITOR=vim

# Dev things
export TESTBED=$HOME/testbed
export HADOOP_HOME=$TESTBED/hadoop
export HBASE_HOME=$TESTBED/hbase
export HUGETABLE_HOME=$TESTBED/hugetable
export PATH=$HUGETABLE_HOME/bin:$HADOOP_HOME/bin:$HBASE_HOME/bin:$PATH
