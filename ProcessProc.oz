%==============
% Code for finding CE in proc value
%
% Author: Shubham Singh
% Date  : Sep 26 2019
%==============

% Pass the statement argument and env

fun {SafeAdjoin Record1 Record2}
  case Record2
  of nil then Record1
  else {Adjoin Record1 Record2}
  end
end

fun {GetProcEnv ConEnv ActualParams FormalParams Env}
    case FormalParams
    of ident(F)|Fs then HandleNewVar in

      fun {HandleNewVar ConEnv}
        {Unify ident(F) ActualParams.1 ConEnv Env}
        {GetProcEnv ConEnv ActualParams.2 Fs Env}
      end

      case ActualParams
      of ident(A)|As then
        {GetProcEnv {Adjoin ConEnv env(F:Env.A)} As Fs Env}
      [] literal(A)|As then
        {HandleNewVar {Adjoin ConEnv env(F:{AddKeyToSAS})}}
      [] [record L P]|As then
        {HandleNewVar {Adjoin ConEnv env(F:{AddKeyToSAS})}}
      [] [procedure Args S]|As then
        {HandleNewVar {Adjoin ConEnv env(F:{AddKeyToSAS})}}
      else raise error('Invalid Parameter in Function') end
      end
    else ConEnv
    end
end

fun {GetFreeVar S Args Env}
    ProcStack = {NewCell nil} ProcTop = {NewCell nil}  ProcIndex = {NewCell 0} PsuedoExec GetFree GetFreeFromList ProcVar ArgsToEnv EnvToArgs Push Pop in

      proc {Push StmtEnvPair}
        ProcStack := StmtEnvPair | @ProcStack
      end

      fun {Pop}
        case @ProcStack
        of nil then nil
        [] StmtEnvPair | RStack then
            ProcStack := RStack
            StmtEnvPair
        end
      end

      % Add Argument to Local env
      fun {ArgsToEnv Args}
        Aux in
          fun {Aux X L}
            case X of
            ident(X1)|T then
            ProcIndex := @ProcIndex + 1
            {Aux T {SafeAdjoin L env(X1:@ProcIndex)}}
            else L
            end
          end
          {Aux Args nil}
      end

      % Hack: Send the Local var of proc as arg inside proc(nested procedure)
      fun {EnvToArgs Env}
        Aux in
          fun {Aux X L}
            case X of
            X#Y|T then
            {Aux T ident(X)|L}
            else L
            end
          end
          {Aux {Record.toListInd Env} nil}
      end

      {Push stk(stmt:S env:{ArgsToEnv Args})}

      % Find free variable which are in Global Env
      % but not in Local Env
      fun {GetFree X Env Free GlobalEnv}
        L HandleRecords in

        % To handle the var/proc in nested record
        fun {HandleRecords Xs Free}
          case Xs of
          nil then Free
          [] ident(X)|T then
            if {Not {HasFeature Env X}} then
              {HandleRecords T {SafeAdjoin Free env(X:GlobalEnv.X)}}
            else {HandleRecords T Free} end
          [] [procedure Args S]|T then
            {HandleRecords T {SafeAdjoin Free {GetFreeVar S {Append Args {EnvToArgs Env}} GlobalEnv}}}
          [] [record Lit Pairs]|T then
            {HandleRecords T {SafeAdjoin Free {HandleRecords {Map Pairs fun {$ X} X.2.1 end} Free}}}
          else {HandleRecords Xs.2 Free}
          end
        end

        case X of
        ident(X1) then
          if {Not {HasFeature Env X1}} then L=X1 else L=nil end
        [] record|Lit|Pairs then L=record
        [] procedure|Args|S then L=procedure
        else L=nil
        end

        case L of
        nil then Free
        [] record then {SafeAdjoin Free {HandleRecords {Map X.2.2.1 fun {$ X} X.2.1 end} Free}}
        [] procedure then {SafeAdjoin Free {GetFreeVar X.2.2.1 {Append X.2.1 {EnvToArgs Env}} GlobalEnv}}
        [] X then {SafeAdjoin Free env(X:GlobalEnv.X)}
        else Free
        end
      end

      fun {GetFreeFromList X Env Free GlobalEnv}
        Utils in
          fun {Utils X Free}
            case X
            of X1|Xs then
              {Utils Xs {GetFree X1 Env Free GlobalEnv}}
            else Free
            end
          end
          {Utils X Free}
      end

      % Proc Variable declaration to update Local Env
      fun {ProcVar X Env}
        DeclareRecord in

        fun {DeclareRecord Pairs Env}
          case Pairs of
          H|T then {DeclareRecord T {ProcVar H Env}}
          else Env
          end
        end

        case X of
        ident(Y) then
          ProcIndex := @ProcIndex + 1
          {SafeAdjoin Env env(Y:@ProcIndex)}
        [] [record L Pairs] then
          {DeclareRecord {Map Pairs fun {$ X} X.2.1 end} Env}
        else raise error('Declartion of variable inside proc') end
        end
      end

      % Exec pseudo proc to extract the free variables used
      fun {PsuedoExec Free}
        ProcTop := {Pop}
        if @ProcTop == nil then Free
        else
          case @ProcTop.stmt of
          nil then {PsuedoExec Free}
          [] [nop] then
            {PsuedoExec Free}
          [] [var X S] then
            {Push stk(stmt: S env: {ProcVar X @ProcTop.env})}
            {PsuedoExec Free}
          [] [bind X Y] then
            {PsuedoExec {GetFreeFromList [X Y] @ProcTop.env Free Env}}
          [] [conditional X S1 S2] then
            {Push stk(stmt:S1 env:@ProcTop.env)}
            {Push stk(stmt:S2 env:@ProcTop.env)}
            {PsuedoExec {GetFree X @ProcTop.env Free Env}}
          [] [match X P S1 S2] then MatchEnv in % if unification fails, do S2
            MatchEnv = {ProcVar P @TopValue.env}
            {Push stk(stmt:S1 env:MatchEnv)}
            {Push stk(stmt:S2 env:@TopValue.env)}
            {PsuedoExec {GetFree X @ProcTop.env Free Env}}
          [] apply|Params then
            {PsuedoExec {GetFreeFromList Params @ProcTop.env Free Env}}
          [] [sum X Y Z] then
            {PsuedoExec {GetFreeFromList [X Y Z] @ProcTop.env Free Env}}
          [] [subtract X Y Z] then
            {PsuedoExec {GetFreeFromList [X Y Z] @ProcTop.env Free Env}}
          [] [divide X Y Z] then
            {PsuedoExec {GetFreeFromList [X Y Z] @ProcTop.env Free Env}}
          [] [product X Y Z] then
            {PsuedoExec {GetFreeFromList [X Y Z] @ProcTop.env Free Env}}
          [] [thrd S] then
            {Push stk(stmt:S env:@ProcTop.env)}
            {PsuedoExec Free}
          [] X|Xs then
            if Xs \=nil then
              {Push stk(stmt:Xs env:@ProcTop.env)}
            end
            {Push stk(stmt:X env: @ProcTop.env)}
            {PsuedoExec Free}
          else Free
          end
        end
      end
      {PsuedoExec nil}
end
