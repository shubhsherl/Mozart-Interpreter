/*
* Author: Shubham Singh
* Interpreter.oz
*/

functor
import
  Browser(browse: Browse)
define
  \insert 'Stack.oz'
  \insert 'SingleAssignmentStore.oz'
  \insert 'ProcessRecords.oz'
  \insert 'ProcessProc.oz'
  \insert 'Unify.oz'
  \insert 'Test.oz'

  TopValue = {NewCell nil}

  fun {DeclareVar X Env}
    DeclareRecord in

    fun {DeclareRecord Pairs Env}
      case Pairs of
      H|T then {DeclareRecord T {DeclareVar H Env}}
      else Env
      end
    end

    case X of
    ident(Y) then {Adjoin Env env(Y:{AddKeyToSAS})}
    [] [record L Pairs] then
      {DeclareRecord {Map Pairs fun {$ X} X.2.1 end} Env}
    else raise error('Declartion of variable') end
    end
  end

  proc {Interpreter AST}
    {Browse stackTop#store}
    {AddStack sepair(stmt:AST env:nil)}
    local InterpreterAux Scheduler in
      proc {InterpreterAux}
        TopValue := {Pop}
        {Browse @TopValue#{Dictionary.entries Store}}
        if @TopValue == nil then {Browse 'Thread Completed'} {Scheduler}
        else
          case @TopValue.stmt of
          nil then {InterpreterAux}
          % skip
          [] [nop] then
            {ResetSuspendCounter}
            {InterpreterAux}
          % local X in S end
          [] [var X S] then
            {Push stk(stmt: S env: {DeclareVar X @TopValue.env})}
            {ResetSuspendCounter}
            {InterpreterAux}
          % X=Y
          [] [bind X Y] then
            {Unify X Y @TopValue.env @TopValue.env}
            {ResetSuspendCounter}
            {InterpreterAux}
          % if P then S1 else S2 end
          [] [conditional ident(P) S1 S2] then Predicate = {RetrieveFromSAS @TopValue.env.P} in
            case Predicate
            of literal(true) then
              {ResetSuspendCounter}
              {Push stk(stmt:S1 env:@TopValue.env)}
            [] literal(false) then
              {ResetSuspendCounter}
              {Push stk(stmt:S2 env:@TopValue.env)}
            [] equivalence(X) then
              {Push @TopValue}
              {SuspendCurrentThread}
            else raise error('unknown error') end
            end
            {InterpreterAux}
          % case x of p then s1 else s2 end
          [] [match ident(X) P S1 S2] then Predicate = {RetrieveFromSAS @TopValue.env.X} CurrentIndex = @Index in
            case Predicate
            of equivalence(X) then
              {Push @TopValue}
              {SuspendCurrentThread}
            else
              {ResetSuspendCounter}
              try MatchEnv in % if unification fails, do S2
                MatchEnv = {DeclareVar P @TopValue.env}
                {Unify ident(X) P MatchEnv MatchEnv} % P==X ? S1 : S2
                {Push stk(stmt:S1 env:MatchEnv)}
              catch incompatibleTypes(_ _) then
                {RemoveKeysfromSAS @Index-CurrentIndex}
                {Push stk(stmt:S2 env:@TopValue.env)}
              end
            end
            {InterpreterAux}
          % 'function application'
          [] apply|ident(F)|Params then Function FuncEnv FuncStmt FuncParams in
            Function = {RetrieveFromSAS @TopValue.env.F}
            case Function
            of equivalence(X) then
              {Push @TopValue}
              {SuspendCurrentThread}
            [] procedure|X then
              {ResetSuspendCounter}
              FuncParams = Function.2.1
              if {Length FuncParams} == {Length Params}then skip
              else raise error('Cannot Apply F on Params') end
              end
              FuncEnv = Function.2.2.2.1
              FuncStmt = Function.2.2.1
              {Push stk(stmt:FuncStmt env:{GetProcEnv FuncEnv Params FuncParams @TopValue.env})}
            else raise error('unknown error') end
            end
            {InterpreterAux}
          [] [sum X Y Z] then
            {Unify Z X#'+'#Y @TopValue.env @TopValue.env}
            {ResetSuspendCounter}
            {InterpreterAux}
          [] [subtract X Y Z] then
            {Unify Z X#'-'#Y @TopValue.env @TopValue.env}
            {ResetSuspendCounter}
            {InterpreterAux}
          [] [divide X Y Z] then
            {Unify Z X#'/'#Y @TopValue.env @TopValue.env}
            {ResetSuspendCounter}
            {InterpreterAux}
          [] [product X Y Z] then
            {Unify Z X#'*'#Y @TopValue.env @TopValue.env}
            {ResetSuspendCounter}
            {InterpreterAux}
          [] [thrd S] then
            {AddStack sepair(stmt:S env:@TopValue.env)}
            {ResetSuspendCounter}
            {InterpreterAux}
          [] X|Xs then
            {ResetSuspendCounter}
            if Xs \=nil then
              {Push stk(stmt:Xs env:@TopValue.env)}
            end
            {Push stk(stmt: X env: @TopValue.env)}
            {InterpreterAux}
          else raise error('Unhandled Statement') end
          end
        end
      end

      proc {Scheduler}
        if @MultiSemanticStack == nil then {Browse 'Interpretation Completed'} else {InterpreterAux} end
      end

      {Scheduler}
    end
  end

{TestCases}
end

