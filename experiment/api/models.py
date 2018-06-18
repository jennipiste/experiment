# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models


class Participant(models.Model):
    """
    Participant belongs into one of 24 groups
    Each group has different order of conditions

    Conditions:
    A = layout 1, 3 dialogs
    B = layout 2, 3 dialogs
    C = Layout 1, 4 dialogs
    D = layout 2, 4 dialogs

    Latin square: (https://explorable.com/counterbalanced-measures-design)
    Group   1st 2nd 3rd 4th
    1       A   B   C   D
    2       A   B   D   C
    3       A   C   B   D
    4       A   C   D   B
    5       A   D   B   C
    6       A   D   C   B
    7       B   A   C   D
    8       B   A   D   C
    9       B   C   A   D
    10      B   C   D   A
    11      B   D   A   C
    12      B   D   C   A
    13      C   A   B   D
    14      C   A   D   B
    15      C   B   A   D
    16      C   B   D   A
    17      C   D   A   B
    18      C   D   B   A
    19      D   A   B   C
    20      D   A   C   B
    21      D   B   A   C
    22      D   B   C   A
    23      D   C   A   B
    24      D   C   B   A
    """
    PARTICIPANT_GROUPS = (
        (1, "group1"),
        (2, "group2"),
        (3, "group3"),
        (4, "group4"),
        (5, "group5"),
        (6, "group6"),
        (7, "group7"),
        (8, "group8"),
        (9, "group9"),
        (10, "group10"),
        (11, "group11"),
        (12, "group12"),
        (13, "group13"),
        (14, "group14"),
        (15, "group15"),
        (16, "group16"),
        (17, "group17"),
        (18, "group18"),
        (19, "group19"),
        (20, "group20"),
        (21, "group21"),
        (22, "group22"),
        (23, "group23"),
        (24, "group24"),
    )
    created_at = models.DateTimeField(auto_now_add=True)
    # Which group participant belongs in
    group = models.IntegerField(choices=PARTICIPANT_GROUPS, null=True)
    # The number of the participant
    number = models.IntegerField(null=True, unique=True)

    def __str__(self):
        return u"number: {0}, group: {1}".format(self.number, self.group)


class ChatDialog(models.Model):
    EXPERIMENT_PARTS = (
        (1, "part1"),
        (2, "part2"),
        (3, "part3"),
        (4, "part4"),
    )
    EXPERIMENT_CONDITIONS = (
        ("A", "conditionA"),
        ("B", "conditionB"),
        ("C", "conditionC"),
        ("D", "conditionD"),
    )
    created_at = models.DateTimeField(auto_now_add=True)
    name = models.CharField(max_length=400)
    subject = models.CharField(max_length=400, null=True)
    participant = models.ForeignKey(Participant)
    experiment_part = models.IntegerField(choices=EXPERIMENT_PARTS, null=True)
    experiment_condition = models.CharField(choices=EXPERIMENT_CONDITIONS, null=True, max_length=2)
    is_ended = models.BooleanField(default=False)
    ended_at = models.DateTimeField(null=True)
    # How many seconds after the current experiment started the dialog was created
    created_after_experiment_part_started = models.DecimalField(max_digits=12, decimal_places=6, null=True)

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
    # How many seconds after the current experiment started the dialog was created
    created_after_experiment_part_started = models.DecimalField(max_digits=12, decimal_places=6, null=True)

    def __str__(self):
        return u"message: {0}, type: {1}, sender: {2}".format(self.message, self.type, self.sender)


class Questionnaire(models.Model):
    VALUES = (
        (1, "täysin eri mieltä"),
        (2, "jokseenkin eri mieltä"),
        (3, "ei samaa eikä eri mieltä"),
        (4, "jokseenkin samaa mieltä"),
        (5, "täysin samaa mieltä"),
    )
    created_at = models.DateTimeField(auto_now_add=True)
    participant = models.ForeignKey(Participant)
    experiment_part = models.IntegerField(choices=ChatDialog.EXPERIMENT_PARTS, null=True)
    experiment_condition = models.CharField(choices=ChatDialog.EXPERIMENT_CONDITIONS, null=True, max_length=2)
    q1 = models.IntegerField(choices=VALUES)
    q2 = models.IntegerField(choices=VALUES)
    q3 = models.IntegerField(choices=VALUES)
    q4 = models.IntegerField(choices=VALUES)
    q5 = models.IntegerField(choices=VALUES)
