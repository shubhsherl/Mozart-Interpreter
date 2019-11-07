MultiSemanticStack = {NewCell nil}
SuspendCounter = {NewCell 0}

%for multiStack
proc {AddStack StmtEnvPair}
  MultiSemanticStack := [StmtEnvPair] | @MultiSemanticStack
end

proc {DeleteSemanticStack}
  MultiSemanticStack := @MultiSemanticStack.2
end

proc {SuspendCurrentThread}
  MultiSemanticStack := {Append @MultiSemanticStack.2 [@MultiSemanticStack.1]}
  {IncreaseSuspendCounter}
  if @SuspendCounter == {Length @MultiSemanticStack} then raise error('deadlock') end else skip end
end

proc {ResetSuspendCounter}
  SuspendCounter := 0
end

proc {IncreaseSuspendCounter}
  SuspendCounter := @SuspendCounter + 1
end

proc {Push StmtEnvPair}
  MultiSemanticStack := (StmtEnvPair|@MultiSemanticStack.1) | @MultiSemanticStack.2
end

fun {Pop}
  case @MultiSemanticStack.1
  of nil then
      {DeleteSemanticStack}
      nil
  [] StmtEnvPair | RemainingStack then
      MultiSemanticStack := RemainingStack | @MultiSemanticStack.2
      StmtEnvPair
  end
end
