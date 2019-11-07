Mozart Oz Interpreter

Files
- Interpreter.oz- Interpreter for AST
- Stack.oz- MultiStack(with cell) with push, pop and multi stack handling functions
- SingleAssignmentStore.oz- SAS(with Dictionary) implementation using dictionary
- ProcessProc.oz- To find the CE for proc value and provide proc env
- Test.oz- Test Cases for Interpreter.
- Unify.oz- Code for unification algorithm (modified)
- ProcessRecords.oz- Code for processing Records (provided)


Cases Handled Successfully:
- Nested records.
- Nested proc(Extract CE)
- Symmetrical binding
- Nested proc->record->proc/ proc->record->record->proc
- Arithemetic operators
- Threads
- Round-Robin thread scheduler

Run the Interpreter
There are sample test cases for corresponding Problems and some Misc Cases(Uncomment to Test) .

- Compile
	`ozc -c Interpreter.oz -o Interpreter`
- Execute
	`ozengine Interpreter`

Mozart Compiler 2.0.0-alpha.0 playing Oz 3
