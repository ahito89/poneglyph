+++
date = "2023-12-05"
title = "Aoc23 Day1"
draft = false
tags = ["scheme","aoc"]
categories = ["Programming"]
slug = "aoc23-day1"
+++

This year I wanted to try to solve some Advent of code problems, and what better way to do it than using a new language, in my case that language is Scheme.

I'm using Windows and scoop to install software so I found this nice scheme implementation called Gauche. So I've started with:

```
>scoop install gauche
>gosh 
```

and now I'm in a nice scheme REPL.

Let's see how you read a file in Scheme.
```
(define input-file (open-input-file "input-file.txt" :if-does-not-exist :error))
```
Using `open-input-file` I get back a port if input-file.txt exists or an error if it doesn't. Now with this port, I have to read the data and here I found this nice method that reads everything and returns a list of strings for each row.
```
(define input-data (port->string-list input-file))
```
Now that I have the puzzle input in `input-data` I can start solving the problem, for reference, the problem text can be found [here](https://adventofcode.com/2023/day/1), basically find the first and last digit in each row, form a number using those digits, and return the sum of all the numbers.

Let's start by writing a function that gets the number from the string:
```
(define (get-number input-string)
    (let ((char-list (filter char-numeric? (string->list input-string))))
    (string->number (string (car char-list) (last char-list)))))
```
What this does is split the string into a list of chars then we filter that list for numeric chars and then take the first and last element from the list combine them and return a number.

The final piece of the puzzle is to fold over the `input-data`
```
input-data
("1abc2" "pqr3stu8vwx" "a1b2c3d4e5f" "treb7uchet")

(fold + 0 (map get-number input-data))

result 142
```
 
 This seems to solve part 1 of the puzzle but surprise surprise there's a second part where we have to take into account digits written as strings for example "one2ast4nine" should be 19 instead of 24. Splitting the string in a list of chars doesn't work for this so let's try finding all the digit positions.

 First I defined all the string digits:

 ```
 (define string-digits '("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
 ```
 ```
 (define digit-list '(1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9))
 ```
now we need to get positions for all of these in a string

```
(define (get-positions f input-string)
 (map (lambda (digit) (f input-string digit)) string-digits))
```
using `f` here because I'll pass `string-scan` and `string-scan-right` to scan from the left when getting the first digit and from the right for the second digit. Here's a helpful `zip` function and the `get-number2` function
```
(define (zip . x) (apply map list x))

(define
 (get-number2 input-string)
 (let
  ((left-number  
     (cadar
      (sort
      (filter (lambda (x) (number? (car x)))
        (zip (get-positions string-scan input-string) digit-list)))))
   (right-number
    (last
    (last
     (sort
       (filter (lambda (x) (number? (car x)))
        (zip (get-positions string-scan-right input-string) digit-list)))))))
  (+ (* 10 left-number) right-number)))

(fold + 0 (map get-number2 input-data))
```

That's about it, not the best solution but good enough for my first try.



