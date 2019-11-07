Store = {Dictionary.new}
Index = {NewCell 0}

fun {AddKeyToSAS}
    Index := @Index + 1
    {Dictionary.put Store @Index equivalence(@Index)}
    @Index
end

proc {RemoveKeysfromSAS Decrease}
    if {And Decrease>0 @Index>0} then
        {Dictionary.remove Store @Index}
        Index := @Index - 1
        {RemoveKeysfromSAS Decrease-1}
    end
end

fun {RetrieveFromSAS Key}
    local Value in
        Value = {Dictionary.get Store Key}
        case Value
        of equivalence(X) then equivalence(X)
        [] reference(X) then {RetrieveFromSAS X}
        else Value
        end
    end
end

proc {BindValueToKeyInSAS Key Val}
    {Dictionary.put Store Key Val}
end

proc {BindRefToKeyInSAS Key RefKey}
    {Dictionary.put Store Key reference(RefKey)}
end
