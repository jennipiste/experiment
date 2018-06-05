# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models


class Participant(models.Model):
    """
    Participant belongs into one of four groups
    Each group has different order of conditions

    Conditions:
    A = layout 1, 3 dialogs
    B = layout 2, 3 dialogs
    C = Layout 1, 4 dialogs
    D = layout 2, 4 dialogs

    Balanced latin square: (https://explorable.com/counterbalanced-measures-design)
    Group   1st 2nd 3rd 4th
    1       A   B   D   C
    2       B   C   A   D
    3       C   D   B   A
    4       D   A   C   B
    """
    PARTICIPANT_GROUPS = (
        (1, "group1"),
        (2, "group2"),
        (3, "group3"),
        (4, "group4"),
    )
    NOTIFICATION_TYPES = (
        (1, "notification1"),  # Passive notification
        (2, "notification2"),  # Aggressive notification
    )
    created_at = models.DateTimeField(auto_now_add=True)
    # Which notification type is shown
    notification = models.IntegerField(choices=NOTIFICATION_TYPES, null=True)
    # Which group participant belongs in
    group = models.IntegerField(choices=PARTICIPANT_GROUPS, null=True)

    def __str__(self):
        return u"id: {0}, group: {1}, notification: {2}".format(self.id, self.group, self.notification)


class ChatDialog(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    name = models.CharField(max_length=400)
    subject = models.CharField(max_length=400, null=True)
    subject_page = models.IntegerField(null=True)
    participant = models.ForeignKey(Participant)
    is_ended = models.BooleanField(default=False)
    ended_at = models.DateTimeField(null=True)
    is_closed = models.BooleanField(default=False)
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
