# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models


class Participant(models.Model):
    created_at = models.DateTimeField(auto_now=True)
    name = models.CharField(max_length=400)


class ChatDialog(models.Model):
    created_at = models.DateTimeField(auto_now=True)
    name = models.CharField(max_length=400)
    participant = models.ForeignKey(Participant)


class ChatMessage(models.Model):
    MESSAGE_TYPES = (
        (1, "incoming"),
        (2, "outgoing"),
    )
    created_at = models.DateTimeField(auto_now=True)
    message = models.TextField()
    sender = models.ForeignKey(Participant, null=True)
    type = models.IntegerField(choices=MESSAGE_TYPES)
    chat_dialog = models.ForeignKey(ChatDialog)
