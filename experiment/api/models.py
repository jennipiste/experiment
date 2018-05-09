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
    subject = models.CharField(max_length=400, null=True)
    participant = models.ForeignKey(Participant)
    is_ended = models.BooleanField(default=False)
    ended_at = models.DateTimeField(null=True)
    closed_at = models.DateTimeField(null=True)

    def __str__(self):
        return u"name: {0}, id: {1}".format(self.name, self.id)


class ChatMessage(models.Model):
    MESSAGE_TYPES = (
        (1, "question"),
        (2, "answer"),
    )
    created_at = models.DateTimeField(auto_now_add=True)
    message = models.TextField()
    sender = models.ForeignKey(Participant, null=True)
    type = models.IntegerField(choices=MESSAGE_TYPES)
    chat_dialog = models.ForeignKey(ChatDialog)
    answer_to = models.ForeignKey('self', null=True)

    def __str__(self):
        return u"message: {0}, type: {1}, sender: {2}".format(self.message, self.type, self.sender)
