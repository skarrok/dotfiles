;; extends

; inspiration from
; https://github.com/ray-x/go.nvim/blob/master/after/queries/go/injections.scm

; Something.objects.raw("SELECT 1")
; (call
;     (attribute
;       attribute: (identifier) @_attribute (#eq? @_attribute "raw")
;     )
;     (argument_list
;       (string
;         (string_content) @sql
;       )
;     )
; )

; general

(
 (string (string_content) @injection.content)
 (#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
 (#set! injection.language "sql")
)
