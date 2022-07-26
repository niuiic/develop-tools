package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func UserController(c *gin.Context) {
	c.JSON(http.StatusOK, "user")
}
