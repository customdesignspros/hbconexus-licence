@echo off
title Update Image Manifest
powershell -ExecutionPolicy Bypass -File "%~dp0update-manifest.ps1"
