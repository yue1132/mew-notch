//
//  GitStatusView.swift
//  MewNotch
//
//  Updated to display multiple active repositories
//

import SwiftUI

struct GitStatusView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var gitManager = GitStatusManager.shared
    @StateObject private var gitDefaults = GitStatusDefaults.shared

    var body: some View {
        VStack(spacing: 6) {
            if gitManager.isRefreshing && gitManager.activeRepositories.isEmpty {
                loadingView
            } else if gitManager.activeRepositories.isEmpty {
                emptyStateView
            } else {
                repositoriesListView
            }
        }
        .padding(8)
        .frame(
            width: notchViewModel.notchSize.height * 4,
            height: notchViewModel.notchSize.height * 3
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            Task {
                await gitManager.refreshStatus()
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 6) {
            ProgressView()
                .scaleEffect(0.7)
                .tint(.white)

            Text("git.loading".localized)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 6) {
            Image(systemName: "questionmark.folder")
                .font(.system(size: 20))
                .foregroundColor(.gray)

            Text("git.noRepository".localized)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray.opacity(0.8))

            Text("git.scanHint".localized)
                .font(.system(size: 8))
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }

    private var repositoriesListView: some View {
        VStack(spacing: 4) {
            ForEach(gitManager.activeRepositories) { repo in
                RepositoryRowView(
                    repo: repo,
                    showUncommittedCount: gitDefaults.showUncommittedCount
                )
            }

            // Refresh indicator
            if gitManager.isRefreshing {
                HStack(spacing: 4) {
                    ProgressView()
                        .scaleEffect(0.4)
                        .tint(.gray)
                    Text("git.refreshing".localized)
                        .font(.system(size: 7))
                        .foregroundColor(.gray.opacity(0.6))
                }
                .padding(.top, 2)
            }
        }
    }
}

struct RepositoryRowView: View {
    let repo: GitStatusModel
    let showUncommittedCount: Bool

    var body: some View {
        VStack(spacing: 3) {
            // Repository name and branch
            HStack(spacing: 6) {
                // Branch icon
                Image(systemName: "branch")
                    .font(.system(size: 10))
                    .foregroundColor(.blue)

                // Branch name
                Text(repo.currentBranch.isEmpty ? "main" : repo.currentBranch)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Spacer()

                // Status indicators
                HStack(spacing: 4) {
                    // Uncommitted count
                    if showUncommittedCount && repo.hasUncommittedChanges {
                        BadgeView(count: repo.uncommittedFiles, color: .orange)
                    }

                    // Sync status
                    if repo.needsSync {
                        SyncIndicatorView(ahead: repo.ahead, behind: repo.behind)
                    }
                }
            }

            // Repository name (secondary info)
            HStack(spacing: 4) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.gray.opacity(0.6))

                Text(repo.repoName)
                    .font(.system(size: 8))
                    .foregroundColor(.gray.opacity(0.7))
                    .lineLimit(1)

                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.06))
        )
    }
}

struct SyncIndicatorView: View {
    let ahead: Int
    let behind: Int

    var body: some View {
        HStack(spacing: 2) {
            if ahead > 0 {
                HStack(spacing: 1) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 7))
                    Text("\(ahead)")
                        .font(.system(size: 7, weight: .medium))
                }
                .foregroundColor(.green)
            }

            if behind > 0 {
                HStack(spacing: 1) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 7))
                    Text("\(behind)")
                        .font(.system(size: 7, weight: .medium))
                }
                .foregroundColor(.orange)
            }
        }
    }
}

struct BadgeView: View {
    let count: Int
    let color: Color

    var body: some View {
        Text("\(count)")
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

#Preview {
    if let screen = NSScreen.main {
        GitStatusView(notchViewModel: NotchViewModel(screen: screen))
    }
}