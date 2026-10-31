;;; -*- lexical-binding: t; -*-
(define-clojure-indent
	(div 1)
	(section 1)
	(ul 1)
	(li 1)
	(table 1)
	(tbody 1)
	(tr 1)
	(th 1)
	(td 1))

(define-clojure-indent
  (defroutes 'defun)
  (GET 2)
  (POST 2)
  (PUT 2)
  (DELETE 2)
  (HEAD 2)
  (ANY 2)
  (context 2))

(define-clojure-indent
	(do-at 1))

(define-clojure-indent
  (form-to 'defun))

(define-clojure-indent
	(test-sequence 'defun)
	(gen/let 'defun)
	(checking 'defun)
	(test-event-sequence 'defun))

(define-clojure-indent
	(where 'defun)
	(where* 'defun)
	(by 'defun)
	(changed 'defun)
	(smap 'defun)
	(tap 'defun)
	(rollup 'defun)
	(throttle 'defun))

(define-clojure-indent
	(describe 'defun)
	(context 'defun)
	(it 'defun)
	(around 'defun))


(define-clojure-indent
	(interest-decision 'defun))

(define-clojure-indent
	(test-api-call 'defun)
	(smoke-test-response 'defun)
	(test-response 'defun)
	(test-response-2 'defun)
	(response-for 'defun)
	(prog1 'defun))

(define-clojure-indent
	(chain 'defun))

(define-clojure-indent
	(default 'defun)
	(smapcat 'defun)
	(handle-docker-request 'defun)
	(docker-fixture 'defun))
