# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-06-05 12:57
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_remove_participant_name'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='chatdialog',
            name='closed_at',
        ),
        migrations.RemoveField(
            model_name='chatdialog',
            name='is_closed',
        ),
        migrations.RemoveField(
            model_name='chatdialog',
            name='subject_page',
        ),
    ]
