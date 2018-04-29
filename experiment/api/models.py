# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models


class Participant(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    name = models.CharField(max_length=400, unique=True)

    def __str__(self):
        return u"name: {0}, id: {1}".format(self.name, self.id)


class ChatDialog(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    name = models.CharField(max_length=400)
    participant = models.ForeignKey(Participant)

    def __str__(self):
        return u"name: {0}, id: {1}".format(self.name, self.id)


class ChatMessage(models.Model):
    MESSAGE_TYPES = (
        (1, "incoming"),
        (2, "outgoing"),
    )
    created_at = models.DateTimeField(auto_now_add=True)
    message = models.TextField()
    sender = models.ForeignKey(Participant, null=True)
    type = models.IntegerField(choices=MESSAGE_TYPES)
    chat_dialog = models.ForeignKey(ChatDialog)

    def __str__(self):
        return u"message: {0}, type: {}, sender: {}".format(self.message, self.type, self.sender)
