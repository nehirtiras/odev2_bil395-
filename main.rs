use std::collections::HashMap;
use std::fmt;
use std::io;

#[derive(Debug)]
enum Expr {
    Number(f64),
    Identifier(String),
    Add(Box<Expr>, Box<Expr>),
    Subtract(Box<Expr>, Box<Expr>),
    Multiply(Box<Expr>, Box<Expr>),
    Divide(Box<Expr>, Box<Expr>),
    Assign(String, Box<Expr>),
}

#[derive(Debug)]
enum CalculatorError {
    ParseError(String),
    VariableNotFound(String),
    DivisionByZero,
    MissingOperand,
    InvalidExpression,
}

impl fmt::Display for CalculatorError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            CalculatorError::ParseError(msg) => write!(f, "Parse error: {}", msg),
            CalculatorError::VariableNotFound(var) => write!(f, "Variable not found: '{}'", var),
            CalculatorError::DivisionByZero => write!(f, "Math error: Division by zero"),
            CalculatorError::MissingOperand => write!(f, "Syntax error: Missing operand"),
            CalculatorError::InvalidExpression => write!(f, "Invalid expression format"),
        }
    }
}

struct Calculator {
    variables: HashMap<String, f64>,
}

impl Calculator {
    fn new() -> Self {
        Calculator {
            variables: HashMap::new(),
        }
    }

    fn evaluate(&mut self, expr: &Expr) -> Result<f64, CalculatorError> {
        match expr {
            Expr::Number(n) => Ok(*n),
            Expr::Identifier(id) => self.variables
                .get(id)
                .copied()
                .ok_or_else(|| CalculatorError::VariableNotFound(id.clone())),
            Expr::Add(lhs, rhs) => Ok(self.evaluate(lhs)? + self.evaluate(rhs)?),
            Expr::Subtract(lhs, rhs) => Ok(self.evaluate(lhs)? - self.evaluate(rhs)?),
            Expr::Multiply(lhs, rhs) => Ok(self.evaluate(lhs)? * self.evaluate(rhs)?),
            Expr::Divide(lhs, rhs) => {
                let rhs_val = self.evaluate(rhs)?;
                if rhs_val == 0.0 {
                    Err(CalculatorError::DivisionByZero)
                } else {
                    Ok(self.evaluate(lhs)? / rhs_val)
                }
            }
            Expr::Assign(id, expr) => {
                let value = self.evaluate(expr)?;
                self.variables.insert(id.clone(), value);
                Ok(value)
            }
        }
    }

    fn parse(&mut self, input: &str) -> Result<Expr, CalculatorError> {
        let trimmed = input.trim();
        if trimmed.is_empty() {
            return Err(CalculatorError::InvalidExpression);
        }

        
        if let Some(equal_pos) = trimmed.find('=') {
            let var = trimmed[..equal_pos].trim();
            if var.is_empty() {
                return Err(CalculatorError::InvalidExpression);
            }
            let expr = trimmed[equal_pos+1..].trim();
            if expr.is_empty() {
                return Err(CalculatorError::MissingOperand);
            }
            return Ok(Expr::Assign(var.to_string(), Box::new(self.parse_expression(expr)?)));
        }

        self.parse_expression(trimmed)
    }

    fn parse_expression(&self, expr: &str) -> Result<Expr, CalculatorError> {
        let mut tokens = Vec::new();
        let mut current_token = String::new();
        let mut paren_level = 0;

        for c in expr.chars() {
            match c {
                ' ' if paren_level == 0 => {
                    if !current_token.is_empty() {
                        tokens.push(current_token.clone());
                        current_token.clear();
                    }
                }
                '(' => {
                    paren_level += 1;
                    current_token.push(c);
                }
                ')' => {
                    if paren_level == 0 {
                        return Err(CalculatorError::ParseError("Mismatched parentheses".to_string()));
                    }
                    paren_level -= 1;
                    current_token.push(c);
                }
                _ => current_token.push(c),
            }
        }

        if !current_token.is_empty() {
            tokens.push(current_token);
        }

        if paren_level != 0 {
            return Err(CalculatorError::ParseError("Mismatched parentheses".to_string()));
        }

        self.build_expression(&tokens)
    }

    fn build_expression(&self, tokens: &[String]) -> Result<Expr, CalculatorError> {
        if tokens.is_empty() {
            return Err(CalculatorError::MissingOperand);
        }

        
        if tokens.len() == 1 {
            return self.parse_atom(&tokens[0]);
        }

        
        for ops in [["*", "/"], ["+", "-"]] {
            for (i, token) in tokens.iter().enumerate().rev() {
                if ops.contains(&token.as_str()) {
                    let left = self.build_expression(&tokens[..i])?;
                    let right = self.build_expression(&tokens[i+1..])?;
                    return match token.as_str() {
                        "+" => Ok(Expr::Add(Box::new(left), Box::new(right))),
                        "-" => Ok(Expr::Subtract(Box::new(left), Box::new(right))),
                        "*" => Ok(Expr::Multiply(Box::new(left), Box::new(right))),
                        "/" => Ok(Expr::Divide(Box::new(left), Box::new(right))),
                        _ => Err(CalculatorError::InvalidExpression),
                    };
                }
            }
        }

        
        if tokens.len() >= 2 && tokens[0] == "(" && tokens[tokens.len()-1] == ")" {
            return self.build_expression(&tokens[1..tokens.len()-1]);
        }

        Err(CalculatorError::InvalidExpression)
    }

    fn parse_atom(&self, token: &str) -> Result<Expr, CalculatorError> {
        if let Ok(num) = token.parse::<f64>() {
            Ok(Expr::Number(num))
        } else if token.chars().all(|c| c.is_alphabetic()) {
            Ok(Expr::Identifier(token.to_string()))
        } else {
            Err(CalculatorError::ParseError(format!("Invalid token: '{}'", token)))
        }
    }
}

fn main() {
    let mut calculator = Calculator::new();

    println!("***Rust Calculator***");

    loop {
        println!("\nEnter expression:");
        let mut input = String::new();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read input");

        let input = input.trim();
        if input.eq_ignore_ascii_case("exit") || input.eq_ignore_ascii_case("quit") {
            break;
        }

        match calculator.parse(input) {
            Ok(expr) => match calculator.evaluate(&expr) {
                Ok(result) => println!("= {}", result),
                Err(e) => println!("Error: {}", e),
            },
            Err(e) => println!("Error: {}", e),
        }
    }
}
