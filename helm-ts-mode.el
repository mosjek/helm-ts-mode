;;; helm-ts-mode.el --- Major mode for Helm templates -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 mosjek
;;
;; Author: mosjek <git@mosjek.org>
;; Maintainer: mosjek <git@mosjek.org>
;; Version: 0.1.0
;; Keywords: languages helm
;; Homepage: https://github.com/mosjek/helm-ts-mode
;; Package-Requires: ((emacs "29.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Provides font-lock for helm templates (https://helm.sh/).
;;
;;  This mode uses the helm dialect from https://github.com/ngalaiko/tree-sitter-go-template for the
;;  tree-sitter grammar.
;;
;;  The queries for syntax highlighting are based on the implementation of the gotmpl and helm
;;  queries from the nvim-treesitter repo (https://github.com/nvim-treesitter/nvim-treesitter).
;;
;;; Code:

(require 'treesit)
(require 'yaml-ts-mode)

(defvar helm-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'helm
   :feature 'identifier
   :override t
   '(
     ([(field) (field_identifier)] @font-lock-variable-name-face)
     ((variable) @font-lock-variable-name-face))

   :language 'helm
   :feature 'function_calls
   :override t
   '(
     (function_call function: (identifier) @font-lock-function-call-face)
     (method_call method: (selector_expression field: (field_identifier)) @font-lock-function-call-face))

   :language 'helm
   :feature 'builtin_functions
   :override t
   `((function_call function: (identifier) @font-lock-builtin-face
      (:match ,(concat "^\\("
                       (string-join '("and" "call" "html" "index" "slice" "js" "len"
                                      "not" "or" "print" "printf" "println" "urlquery"
                                      "eq" "ne" "lt" "ge" "gt" "ge")
                                    "\\|")
                       "\\)$") @font-lock-builtin-face)))

   :language 'helm
   :feature 'operators
   :override t
   '((["|" "=" ":="] @font-lock-operator-face))

   :language 'helm
   :feature 'delimiters
   :override t
   '((["." ","] @font-lock-delimiter-face)
     (["{{" "}}" "{{-" "-}}" ")" "("] @font-lock-bracket-face))

   :language 'helm
   :feature 'actions
   :override t
   '((if_action ["if" "else" "else if" "end"] @font-lock-keyword-face)
     (range_action ["range" "else" "end"] @font-lock-keyword-face)
     (template_action "template" @font-lock-builtin-face)
     (block_action ["block" "end"] @font-lock-keyword-face)
     (define_action ["define" "end"] @font-lock-keyword-face)
     (with_action ["with" "else" "end"] @font-lock-keyword-face))

   :language 'helm
   :feature 'literals
   :override t
   '(([(interpreted_string_literal) (raw_string_literal)] @font-lock-string-face)
     ([(rune_literal)] @font-lock-string-face)
     ([(escape_sequence)] @font-lock-string-face)
     ([(int_literal) (imaginary_literal)] @font-lock-number-face)
     ((float_literal) @font-lock-number-face)
     ([(true) (false)] @font-lock-constant-face)
     ([(nil)] @font-lock-constant-face))

   :language 'helm
   :feature 'comments
   :override t
   '(((comment) @font-lock-comment-face))

   :language 'helm
   :feature 'builtin_functions
   :override t
   `(((function_call function: (identifier) @font-lock-builtin-face)
      (:match ,(concat "^\\("
                       (string-join '("and" "or" "not" "eq" "ne" "lt" "le" "gt" "ge" "default"
                                      "required" "empty" "fail" "coalesce" "ternary" "print"
                                      "println" "printf" "trim" "trimAll" "trimPrefix" "trimSuffix"
                                      "lower" "upper" "title" "untitle" "repeat" "substr" "nospace"
                                      "trunc" "abbrev" "abbrevboth" "initials" "randAlphaNum"
                                      "randAlpha" "randNumeric" "randAscii" "wrap" "wrapWith"
                                      "contains" "hasPrefix" "hasSuffix" "quote" "squote" "cat"
                                      "indent" "nindent" "replace" "plural" "snakecase" "camelcase"
                                      "kebabcase" "swapcase" "shuffle" "toStrings" "toDecimal"
                                      "toJson" "mustToJson" "toPrettyJson" "mustToPrettyJson"
                                      "toRawJson" "mustToRawJson" "fromYaml" "fromJson"
                                      "fromJsonArray" "fromYamlArray" "toYaml" "regexMatch"
                                      "mustRegexMatch" "regexFindAll" "mustRegexFinDall" "regexFind"
                                      "mustRegexFind" "regexReplaceAll" "mustRegexReplaceAll"
                                      "regexReplaceAllLiteral" "mustRegexReplaceAllLiteral"
                                      "regexSplit" "mustRegexSplit" "sha1sum" "sha256sum"
                                      "adler32sum" "htpasswd" "derivePassword" "genPrivateKey"
                                      "buildCustomCert" "genCA" "genSelfSignedCert" "genSignedCert"
                                      "encryptAES" "decryptAES" "now" "ago" "date" "dateInZone"
                                      "duration" "durationRound" "unixEpoch" "dateModify"
                                      "mustDateModify" "htmlDate" "htmlDateInZone" "toDate"
                                      "mustToDate" "dict" "get" "set" "unset" "hasKey" "pluck" "dig"
                                      "merge" "mustMerge" "mergeOverwrite" "mustMergeOverwrite"
                                      "keys" "pick" "omit" "values" "deepCopy" "mustDeepCopy"
                                      "b64enc" "b64dec" "b32enc" "b32dec" "list" "first" "mustFirst"
                                      "rest" "mustRest" "last" "mustLast" "initial" "mustInitial"
                                      "append" "mustAppend" "prepend" "mustPrepend" "concat"
                                      "reverse" "mustReverse" "uniq" "mustUniq" "without"
                                      "mustWithout" "has" "mustHas" "compact" "mustCompact" "index"
                                      "slice" "mustSlice" "until" "untilStep" "seq" "add" "add1"
                                      "sub" "div" "mod" "mul" "max" "min" "len" "addf" "add1f"
                                      "subf" "divf" "mulf" "maxf" "minf" "floor" "ceil" "round"
                                      "getHostByName" "base" "dir" "clean" "ext" "isAbs" "kindOf"
                                      "kindIs" "typeOf" "typeIs" "typeIsLike" "deepequal" "semver"
                                      "semverCompare" "urlParse" "urlJoin" "urlquery" "lookup"
                                      "include")
                                    "\\|")
                       "\\)$") @font-lock-builtin-face)))


   :language 'helm
   :feature 'builtin_constants
   :override t
   `(((selector_expression operand:
       (field name: (identifier) @font-lock-builtin-face)
       field: (field_identifier))
      (:match ,(concat "^\\("
                       (string-join '("Values" "Chart" "Release" "Capabilities" "Files" "Subcharts"
                                      "Template")
                                    "\\|")
                       "\\)$") @font-lock-builtin-face))

     ((selector_expression operand: (variable) field: (field_identifier) @font-lock-builtin-face)
      (:match ,(concat "^\\("
                       (string-join '("Values" "Chart" "Release" "Capabilities" "Files" "Subcharts"
                                      "Template")
                                    "\\|")
                       "\\)$") @font-lock-builtin-face)))))

(define-derived-mode helm-ts-mode yaml-ts-mode "helm"
  "Major mode for editing helm templates, powered by tree-sitter."
  :group 'helm

  (when (treesit-ready-p 'helm)
    (treesit-parser-create 'helm)

    ;; Comments.
    (setq-local comment-start "{{/*")
    (setq-local comment-end "*/}}")

    ;; Indentation.
    (setq-local indent-tabs-mode nil)

    ;; Font-lock.
    (setq-local treesit-font-lock-settings helm-ts-mode--font-lock-settings)
    (setq-local treesit-font-lock-feature-list
                '((identifier function_calls builtin_functions operators delimiters actions literals
                   comments builtin_constants)))

    (treesit-major-mode-setup)))

(provide 'helm-ts-mode)
;;; helm-ts-mode.el ends here
