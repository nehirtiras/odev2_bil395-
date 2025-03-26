with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

procedure Calculator is
   package Float_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Float,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");
   
   Variables : Float_Maps.Map;
   
   type Expression is interface;
   type Expression_Access is access all Expression'Class;
   
   function Evaluate(E : Expression) return Float is abstract;
   
   type Number is new Expression with record
      Value : Float;
   end record;
   
   overriding function Evaluate(E : Number) return Float;
   
   type Variable is new Expression with record
      Name : Unbounded_String;
   end record;
   
   overriding function Evaluate(E : Variable) return Float;
   
   type Binary_Operation is abstract new Expression with record
      Left, Right : Expression_Access;
   end record;
   
   type Addition is new Binary_Operation with null record;
   overriding function Evaluate(E : Addition) return Float;
   
   type Subtraction is new Binary_Operation with null record;
   overriding function Evaluate(E : Subtraction) return Float;
   
   type Multiplication is new Binary_Operation with null record;
   overriding function Evaluate(E : Multiplication) return Float;
   
   type Division is new Binary_Operation with null record;
   overriding function Evaluate(E : Division) return Float;
   
   type Assignment is new Expression with record
      Var_Name : Unbounded_String;
      Expr     : Expression_Access;
   end record;
   
   overriding function Evaluate(E : Assignment) return Float;
   
   -- Implementations of Evaluate functions
   overriding function Evaluate(E : Number) return Float is
   begin
      return E.Value;
   end Evaluate;
   
   overriding function Evaluate(E : Variable) return Float is
   begin
      if Variables.Contains(To_String(E.Name)) then
         return Variables.Element(To_String(E.Name));
      else
         Put_Line("Error: Variable '" & To_String(E.Name) & "' not defined");
         raise Constraint_Error;
      end if;
   end Evaluate;
   
   overriding function Evaluate(E : Addition) return Float is
   begin
      return Evaluate(E.Left.all) + Evaluate(E.Right.all);
   end Evaluate;
   
   overriding function Evaluate(E : Subtraction) return Float is
   begin
      return Evaluate(E.Left.all) - Evaluate(E.Right.all);
   end Evaluate;
   
   overriding function Evaluate(E : Multiplication) return Float is
   begin
      return Evaluate(E.Left.all) * Evaluate(E.Right.all);
   end Evaluate;
   
   overriding function Evaluate(E : Division) return Float is
      Right_Val : constant Float := Evaluate(E.Right.all);
   begin
      if Right_Val = 0.0 then
         Put_Line("Error: Division by zero");
         raise Constraint_Error;
      end if;
      return Evaluate(E.Left.all) / Right_Val;
   end Evaluate;
   
   overriding function Evaluate(E : Assignment) return Float is
      Value : constant Float := Evaluate(E.Expr.all);
   begin
      Variables.Include(To_String(E.Var_Name), Value);
      return Value;
   end Evaluate;
   
   function Parse_Expression(Input : String) return Expression_Access;
   
   function Parse_Term(Input : String) return Expression_Access is
      Pos : Natural;
   begin
      
      begin
         return new Number'(Value => Float'Value(Input));
      exception
         when Constraint_Error =>
            null;
      end;
      
      
      if Input(Input'First) in 'a'..'z' | 'A'..'Z' then
         return new Variable'(Name => To_Unbounded_String(Input));
      end if;
      
      
      if Input(Input'First) = '(' and Input(Input'Last) = ')' then
         return Parse_Expression(Input(Input'First+1..Input'Last-1));
      end if;
      
      
      Pos := Index(Input, "+");
      if Pos > 0 then
         return new Addition'(
            Left  => Parse_Expression(Input(Input'First..Pos-1)),
            Right => Parse_Expression(Input(Pos+1..Input'Last)));
      end if;
      
      Pos := Index(Input, "-");
      if Pos > 0 then
         return new Subtraction'(
            Left  => Parse_Expression(Input(Input'First..Pos-1)),
            Right => Parse_Expression(Input(Pos+1..Input'Last)));
      end if;
      
      Pos := Index(Input, "*");
      if Pos > 0 then
         return new Multiplication'(
            Left  => Parse_Term(Input(Input'First..Pos-1)),
            Right => Parse_Term(Input(Pos+1..Input'Last)));
      end if;
      
      Pos := Index(Input, "/");
      if Pos > 0 then
         return new Division'(
            Left  => Parse_Term(Input(Input'First..Pos-1)),
            Right => Parse_Term(Input(Pos+1..Input'Last)));
      end if;
      
      Put_Line("Error: Invalid expression '" & Input & "'");
      raise Constraint_Error;
   end Parse_Term;
   
   function Parse_Expression(Input : String) return Expression_Access is
      Equal_Pos : constant Natural := Index(Input, "=");
   begin
      if Equal_Pos > 0 then
         declare
            Var_Name : constant String := Trim(Input(Input'First..Equal_Pos-1), Both);
            Expr_Str : constant String := Trim(Input(Equal_Pos+1..Input'Last), Both);
         begin
            if Var_Name = "" then
               Put_Line("Error: Missing variable name in assignment");
               raise Constraint_Error;
            end if;
            
            if Expr_Str = "" then
               Put_Line("Error: Missing expression in assignment");
               raise Constraint_Error;
            end if;
            
            return new Assignment'(
               Var_Name => To_Unbounded_String(Var_Name),
               Expr     => Parse_Expression(Expr_Str));
         end;
      else
         return Parse_Term(Input);
      end if;
   end Parse_Expression;
   
   Input_Line : Unbounded_String;
begin
   Put_Line("ADA Calculator (type 'exit' to quit)");
   Put_Line("Supports: + - * /, variables (x = 5 + 3)");
   
   loop
      Put("> ");
      Input_Line := To_Unbounded_String(Get_Line);
      
      exit when To_String(Input_Line) = "exit";
      
      declare
         Expr : Expression_Access;
      begin
         Expr := Parse_Expression(To_String(Input_Line));
         Put("Result: ");
         Put(Evaluate(Expr.all), Fore => 0, Aft => 2, Exp => 0);
         New_Line;
      exception
         when Constraint_Error =>
            null;
      end;
   end loop;
end Calculator;
