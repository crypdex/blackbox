package validator

import "gopkg.in/go-playground/validator.v9"

type CustomValidator struct {
	validator *validator.Validate
}

func (cv *CustomValidator) Validate(i interface{}) error {
	return cv.validator.Struct(i)
}

func New() *CustomValidator {
	return &CustomValidator{validator: validator.New()}
}
