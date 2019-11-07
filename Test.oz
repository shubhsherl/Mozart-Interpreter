
% proc {X Y1 Y2 .. Yn} S end: [procedure [ident(X) ident(Y1) .. ident(Yn)] S]
% X=Y: [bind ident(X) ident(Y)]
% local X in S end: [var ident(X) S]
% if X then S1 else S2: [condition ident(X) S1 S2]
% case X of P then S1 else S2 end: [match ident(X) P S1 S2]
% {X Y1 Y2 .. Yn}: [apply ident(X) ident(Y1) .. ident(Yn)} X is a procedure.
% Z = X + Y: [sum ident(X) ident(Y) ident(Z)]
% Z = X * Y: [product ident(X) ident(Y) ident(Z)]
% thread S end: [thrd S]

proc {TestCases}
% To Test Problem 1
 %{Interpreter [[[nop]]]}
 %{Interpreter [[nop] [nop] [nop]]}

% To Test Problem 2
 %{Interpreter [[nop] [var ident(x) [nop]] [nop]]}
 %{Interpreter  [var ident(x)
 %                [var ident(y)
 %                     [var ident(x)
 %                            [var ident(x)
 %                             [[nop][nop]]
 %                     ]
 %                ]
 %            ]]
 %}

 % {Interpreter  [var ident(x)
 %                [var ident(y)
 %                     [var ident(x)
 %                            [bind ident(x) ident(y)]
 %                ]
 %            ]]
 %}

 %  {Interpreter  [var ident(x)
 %                [var ident(y)
 %                     [[var ident(x)
 %                            [[bind ident(x) literal(200)]
 %                            [bind ident(y) literal(200)]]
 %                            ]
 %                     [bind ident(y) literal(200)]
 %                     ]
 %                ]
 %            ]
 %}

% To Test Problem 3
%{Interpreter  [var ident(x)
%                [[var ident(y)
%                  [bind ident(x) ident(y)]
%                ]
%                [bind ident(x) literal(10)]
%               ]
%            ]
%}

% To Test Problem 4a and 5a
 %{Interpreter  [var ident(x)
 %               [bind ident(x) [record literal(rec) [
 %                 [literal(a) literal(10)]
 %                 [literal(b) literal(11)]
 %                 [literal(c) literal(12)]
 %             ]]
 %           ]]
 %         }
 %{Interpreter  [record literal(rec) [
 %                 [literal(a) literal(10)]
 %                 [literal(b) literal(11)]
 %                 [literal(c) literal(12)]
 %             ]
 %         ]}
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [
%                        [bind ident(x) [record literal(a) [[literal(f1) ident(y)]]]]
%                        [bind ident(y) literal(100)]
%                    ]
%                ]
%            ]
%}

% To Test Problem 4b 5b
%{Interpreter  [var ident(z)
%                  [var ident(x)
%                      [var ident(w)
%                          [
%                            [bind ident(x) [procedure [ident(y)] [
%                                                        [bind ident(y) literal(20)]
%                                                        [bind ident(w) [procedure [ident(z)] [[bind ident(z) literal(10)]
%                                                                            [bind ident(y) literal(20)]]]]
%                                                        ]
%                                      ]
%                        ]
%                        [apply ident(x) literal(20)]
%                    ]
%                ]
%             ]
%            ]
%}

%{Interpreter  [var ident(x)
%                [var ident(z1)
%                  [var ident(z2)
%                      [var ident(z3)
%                          [
%                            [bind ident(x) [procedure [ident(y1) ident(y2) ident(y3)]
%                                                          [var ident(z) [
%                                                                [bind ident(y1) literal(20)]
%                                                                [bind ident(y2) ident(y3)]
%                                                                [bind ident(y3) literal(30)]
%                                                                [bind ident(z) ident(y3)]
%                                                            ]

%                                                        ]
%                                      ]
%                        ]
%                        [apply ident(x) ident(z1) ident(z2) ident(z3)]
%                    ]
%                ]
%              ]
%            ]
%          ]
%}

%{Interpreter  [var ident(ans)
%                [var ident(sq)
%                [var ident(sum)
%                  [var ident(f)
%                      [
%                        [bind ident(sq) [procedure [ident(x) ident(y)] [product ident(x) ident(x) ident(y)]]]
%                        [bind ident(sum) [procedure [ident(a) ident(b) ident(c)] [sum ident(a) ident(b) ident(c)]]]
%                        [bind ident(f) [procedure [ident(a) ident(b) ident(c)] [
%                            [var ident(a2)
%                                [var ident(b2)
%                                    [
%                                          [apply ident(sq) ident(a) ident(a2)]
%                                          [apply ident(sq) ident(b) ident(b2)]
%                                          [apply ident(sum) ident(a2) ident(b2) ident(c)]
%                                      ]]]
%                              ]]]
%                        [apply ident(f) literal(3) literal(4) ident(ans)]

%                ]
%              ]
%            ]
%          ]
%          ]
%}
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind ident(x) [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [bind ident(y1) [procedure [ident(u)] [[bind ident(u) literal(12)]]]]
%                                              [bind ident(y2) [record literal(a) [[literal(f1) ident(x)]]]]
%                                              [apply ident(y1) ident(y)]
%                                              [apply ident(y1) ident(x1)]
%                                            ]
%                                          ]
%                                        ]
%                                      ]
%                        ]
%                        [apply ident(x) literal(12)]
%                        [bind ident(y) literal(12)]
%                    ]
%                ]
%             ]
%}

%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [conditional ident(x) [bind ident(y) literal(1)] [bind ident(y) literal(0)]]
%                        ]
%                    ]
%                ]

%}

%Misc proc inside record
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind ident(x) [record literal(a) [[literal(p) [procedure [ident(z)] [bind ident(y) ident(z)]]] [literal(q) ident(y)]]]]
%                        [bind ident(y) literal(100)]
%                    ]
%                ]
%             ]
%}
%{Interpreter  [var ident(y)
%                   [
%                       [bind ident(y) [record literal(a) [[literal(p) [procedure [ident(z)]
%                                                                  [bind ident(y) ident(z)]]] [literal(q) ident(y)]]]]
%                    ]
%              ]
%}

% Misc: Nested proc to extract CE
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [bind ident(y1) [procedure [ident(x)] [var ident(x5) [bind ident(y1) ident(y)]]]]
%                                              [bind ident(y2) [record literal(a) [[literal(f1) ident(x)]]]]
%                                            ]
%                                          ]
%                                        ]
%                                      ]
%                        ident(x) ]
%                        [bind ident(y) literal(100)]
%                    ]
%                ]
%             ]
%}
% ****
% Misc: proc inside record in another proc
% ****
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [bind ident(y1) [procedure [ident(x)] [var ident(x5) [bind ident(y1) ident(x)]]]]
%                                              [bind ident(y2) [record literal(a) [[literal(f1)
%                                                [procedure [ident(y1)] [bind ident(y2) ident(y)]]
%                                              ] [literal(f2) ident(x)] ]]]
%                                            ]
%                                          ]
%                                        ]
%                                      ]
%                        ident(x) ]
%                        [bind ident(y) literal(100)]
%                    ]
%                ]
%             ]
%}
% Misc: proc->record->record->proc
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [bind ident(y1) [procedure [ident(x)] [var ident(x5) [bind ident(y1) ident(x)]]]]
%                                              [bind ident(y2) [record literal(a) [[literal(f1)
%                                                [record literal(b) [[literal(p) [procedure [ident(y1)] [bind ident(y2) ident(y)]]]]]
%                                              ] [literal(f2) ident(x)] ]]]
%                                            ]
%                                          ]
%                                        ]
%                                      ]
%                        ident(x) ]
%                        [bind ident(y) literal(100)]
%                    ]
%                ]
%             ]
%}
% Misc: Will fail to bind proc to proc
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [bind ident(y1) [procedure [ident(x)] [var ident(x5) [bind ident(y1) ident(x)]]]
%                                              [bind ident(y1) ident(x)]
%                                            ]
%                                          ]
%                                        ]
%                                      ]]
%                        [procedure [ident(x)] [var ident(x1) [bind ident(x1) ident(x)]]]]
%                    ]
%                ]
%             ]
%}
% Misc: Incompatible binding
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [bind ident(y1) [procedure [ident(x)] [var ident(x5) [bind ident(y1) ident(x)]]]
%                                              [bind ident(y1) ident(x)]
%                                            ]
%                                          ]
%                                        ]
%                                      ]]
%                        ident(x)]
%                        [bind ident(y) [procedure [ident(x)] [var ident(x1) [bind ident(x1) ident(x)]]]]
%                        [bind ident(x) ident(y)]
%                    ]
%                ]
%             ]
%}
% Misc: nested record unification e.g. "record(1:X 2:3) = record(1:4 2:Y)"
%{Interpreter [var ident(x) [
%                    var ident(y) [
%                      var ident(z) [
%                        var ident(a) [
%                           [
%                           [bind ident(x) [record literal(a) [[literal(f1) ident(y)] [literal(f2) literal(3)]]]]
%                           [bind ident(z) [record literal(a) [[literal(f1) literal(4)] [literal(f2) ident(a)]]]]
%                           [bind ident(x) ident(z)]
%                           ]]]]]
%                ]
%}

% Misc: where Unification should fail
%{Interpreter [var ident(x)
%                [[var ident(y)
%                    [[bind ident(x) ident(y)]
%                     [bind ident(y) literal(10)]
%                    ]
%                ]
%                [bind ident(x) literal(12)]
%                ]
%              ]
%}

% To Test Problem 6
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [
%                        [bind ident(x) literal(true)]
%                        [conditional ident(x)
%                            [bind ident(y) literal(42)]
%                            [bind ident(y) literal(0)]
%                        ]
%                    ]
%                ]
%            ]
%}

% To Test Problem 7
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [
%                    [bind ident(y) literal(20)]
%                    [bind ident(x) [record literal(rec) [[literal(a) literal(100)] [literal(b) literal(200)]]]]
%                    [match ident(x) [record literal(rec) [[literal(a) ident(y)] [literal(d) ident(z)]]]
%                                [bind ident(y) literal(100)]
%                                [bind ident(y) literal(30)]
%                    ]
%                    ]
%                ]
%            ]
%}

{Interpreter  [var ident(x)
                [var ident(y)
                    [var ident(z)
                        [
                            [bind ident(x) [record literal(a) [[literal(f1) literal(100)]]]]
                            [match ident(x) [record literal(a) [[literal(f2) ident(n)]]]
                                [bind ident(z) ident(n)]
                                [bind ident(z) literal(0)]
                            ]
                        ]
                    ]
                ]
            ]
}

% To Test Problem 8
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [var ident(z)
%                        [
%                            [bind ident(z) literal(100)]
%                            [bind ident(x)  [procedure [ident(p1) ident(p2)]
%                                                [
%                                                    [nop]
%                                                    [var ident(u)
%                                                        [bind ident(u) ident(p1)]
%                                                    ]
%                                                    [var ident(v)
%                                                        [bind ident(v) ident(z)]
%                                                    ]
%                                                ]
%                                            ]
%                            ]
%                            [apply ident(x) ident(y) ident(z)]
%                        ]
%                    ]
%                ]
%            ]
%}
% Misc: Passing literals in apply
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [var ident(z)
%                        [
%                            [bind ident(z) literal(100)]
%                            [bind ident(x)  [procedure [ident(p1) ident(p2)]
%                                                [
%                                                    [var ident(u)
%                                                        [bind ident(u) ident(p2)]
%                                                    ]
%                                                    [var ident(v)
%                                                        [bind ident(v) ident(z)]
%                                                    ]
%                                                ]
%                                            ]
%                            ]
%                            [apply ident(x) ident(y) literal(10)]
%                        ]
%                    ]
%                ]
%            ]
%}

% Misc: Passing proc in apply
%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind ident(y) literal(3)]
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [apply ident(x1) ident(y1)]
%                                              [bind ident(y1) ident(y2)]
%                                            ]
%                                          ]
%                                        ]
%                                      ]
%                        ident(x)]
%                        [apply ident(x) [procedure [ident(x)] [var ident(x1) [bind ident(x1) ident(y)]]]]
%                    ]
%                ]
%             ]
%}

% To Test Problem 9
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [var ident(z)
%                        [
%                            [product literal(2) literal(3) literal(6)]
%                            [bind ident(y) literal(5)]
%                            [product literal(8) ident(y) ident(z)]
%                            [sum ident(z) ident(y) ident(x)]
%                        ]
%                    ]
%                ]
%            ]
%}

%Arithmetic Operators
%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [var ident(z)
%                        [var ident(u)
%                            [
%                              [product literal(2) literal(4) ident(x)]
%                              [subtract literal(20) ident(x) ident(y)]
%                              [sum ident(y) ident(x) ident(z)]
%                              [divide ident(x) ident(z) ident(u)]
%                            ]
%                        ]
%                    ]
%                ]
%            ]
%}


% ---------------------------
% Threads
% ---------------------------
%{Interpreter [thrd [[nop] [nop] [nop]]]}

%basic thread test
%{Interpreter  [var ident(x)
%                [var ident(y)
%                  [
%                    [thrd [conditional ident(x)
%                            [bind ident(y) literal(12)]
%                            [bind ident(y) literal(100)]
%                          ]
%                    ]
%                    [thrd [bind ident(x) literal(false)]]
%                ]
%            ]
%        ]
%}

% All threads get suspended(deadlock)
%{Interpreter  [var ident(x)
%                [var ident(y)
%                  [
%                    [thrd [conditional ident(y)
%                              [bind ident(x) literal(true)]
%                              [bind ident(x) literal(false)]
%                          ]
%                    ]
%                    [thrd [conditional ident(x)
%                              [bind ident(y) literal(true)]
%                              [bind ident(y) literal(false)]
%                          ]
%                    ]
%                  ]
%                ]
%          ]
%}

%{Interpreter  [var ident(x)
%                [var ident(y)
%                    [var ident(z)
%                        [
%                            [bind ident(x)  [procedure [ident(p1)]
%                                                [
%                                                    [conditional ident(p1)
%                                                      [bind ident(y) literal(78)]
%                                                      [bind ident(y) literal(43)]
%                                                    ]
%                                                ]
%                                            ]
%                            ]
%                            [thrd [apply ident(x) ident(z)]]
%                            [thrd [bind ident(z) literal(true)]]
%                        ]
%                    ]
%                ]
%            ]
%}

%{Interpreter  [var ident(x)
%               [var ident(y)
%                   [
%                       [bind [procedure [ident(x1)] [var ident(y1) [var ident(y2)
%                                            [
%                                              [thrd [bind ident(y) literal(3)]]
%                                              [apply ident(x1) ident(y1)]
%                                              [thrd [bind ident(y1) ident(y2)]]
%                                            ]
%                                          ]
%                                        ]
%                                      ]
%                        ident(x)]
%                        [apply ident(x) [procedure [ident(x)] [var ident(x1) [bind ident(x1) ident(y)]]]]
%                    ]
%                ]
%             ]
%}
end